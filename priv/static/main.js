

let charge = 20; // charge value from a dot.
const multiplier = 10; // how much to enlarge input canvas ()
const ws = new WebSocket(`ws://${location.host}/websocket`);
const util = {now: Date.now() }; // object to hopefully save time on generating current time
let max = 1; // max impulses per time frame.  this will be updated at runtime, and it determines the opacity of output points
const TIME_FRAME = 100; // length of timeframe in ms to calculate ganglion firing rate
const INPUT_INTERVAL = 20;

// canvas setup
const inputCanvas = document.querySelector('#input');
const inputContext = inputCanvas.getContext('2d');
const shadowCanvas = document.createElement('canvas');
shadowCanvas.height = inputCanvas.height / multiplier;
shadowCanvas.width = inputCanvas.width / multiplier;
const shadowContext = shadowCanvas.getContext('2d');
const outputCanvas = document.querySelector('#output');
const outputContext = outputCanvas.getContext('2d');
inputContext.fillStyle = "rgba(0,0,0,255)";

let drawing = false;
const listener = e => {
  const shadowX = Math.floor(e.layerX / multiplier);
  const shadowY = Math.floor(e.layerY / multiplier);
  const x = shadowX * multiplier;
  const y = shadowY * multiplier;
  switch (e.type) {
    case 'mousedown':
      inputContext.fillRect(x, y, multiplier, multiplier);
      shadowContext.fillRect(shadowX, shadowY, 1, 1);
      drawing = true;
      break;
    case 'mousemove':
      if (drawing) {
        inputContext.fillRect(x, y, multiplier, multiplier);
        shadowContext.fillRect(shadowX, shadowY, 1, 1);
      }
      break;
    case 'mouseup':
      drawing = false;
  }
};

inputCanvas.addEventListener('mousedown', listener, false);
inputCanvas.addEventListener('mousemove', listener, false);
inputCanvas.addEventListener('mouseup', listener, false);

document.querySelector('button').addEventListener('click', () => {
  inputContext.clearRect(0, 0, inputCanvas.width, inputCanvas.height);
  shadowContext.clearRect(0, 0, shadowCanvas.width, shadowCanvas.height);
}, false);


const colorPixel = (x, y, hit) => {
  let alpha = hit / max;
  outputContext.clearRect(x, y, 10, 10);
  outputContext.fillStyle = `rgba(0,0,0,${alpha})`;
  outputContext.fillRect(x, y, 10, 10);
};

// stores the hits (impulses) for a given ganglion
const hits = {};

// update impulse count and draw output on incoming messages
ws.onmessage = (message) => {
  const m = JSON.parse(message.data);
  const x = m[1] * 10;
  const y = m[0] * 10;
  const key = x + '-' + y;
  let hit = hits[key];
  hits[key] = hits[key] || [];
  hit = hits[key] = hits[key].concat([util.now]);
  colorPixel(x, y, hit.length);
};
//
// // continuously send input info to server
const interval = setInterval(() => {
  util.now = Date.now();
  const height = shadowCanvas.height;
  const width = shadowCanvas.width;
  const data = shadowContext.getImageData(
    0,
    0,
    width,
    height
  ).data;
  const length = width * height;
  let inputs = [];
  for(let i = 0; i < length; i++) {
    if (data[(i * 4 + 3)] > 230) {
      inputs.push([
        i % width, // x
        Math.floor(i / height), // y
        charge // charge
      ]);
    }
  }

  if (inputs.length) {
    ws.send(JSON.stringify(inputs));
  }
}, INPUT_INTERVAL);

// ws cleanup
ws.onclose = () => clearInterval(interval);
//
// // calculate ganglion firing rate
setInterval(() => {
  Object.keys(hits).forEach(key => {
    let hit = hits[key];
    if (hit.length > max) {
      max = hit.length;
    }
    hit = hits[key] = hit.filter(time => util.now - time < TIME_FRAME + 1);
    const coords =  key.split('-');
    const x = coords[0];
    const y = coords[1];
    colorPixel(x, y, hit.length);
  });
}, TIME_FRAME);
