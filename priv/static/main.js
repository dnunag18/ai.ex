

// draw input canvas
// allow click drawing?

// draw output canvas
// websocket handler.  clear out pixel after 500ms?


const inputCanvas = document.querySelector('#input');
const inputContext = inputCanvas.getContext('2d');
const multiplier = 10;
const shadowCanvas = document.createElement('canvas');
shadowCanvas.height = inputCanvas.height / multiplier;
shadowCanvas.width = inputCanvas.width / multiplier;
const shadowContext = shadowCanvas.getContext('2d');
const outputCanvas = document.querySelector('#output');
const outputContext = outputCanvas.getContext('2d');
inputContext.fillStyle = "rgba(0,0,0,255)";

let drawing = false;
//
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

const ws = new WebSocket(`ws://${location.host}/websocket`);

let charge = 4;
// let threshold = 85;
const colorPixel = (x, y, hit) => {
  let alpha = hit / 10;
  outputContext.clearRect(x, y, 10, 10);
  outputContext.fillStyle = `rgba(0,0,0,${alpha})`;
  outputContext.fillRect(x, y, 10, 10);
};
const hits = {};
ws.onmessage = (message) => {
  const m = JSON.parse(message.data);
  const x = m[1] * 10;
  const y = m[0] * 10;
  const key = x + '-' + y;
  let hit = hits[key];
  hits[key] = hits[key] || {val: 0, time: util.now};
  hit = hits[key] = {val: Math.min(10, ++hits[key].val), time: util.now};
  colorPixel(x, y, hit.val);
};
let interval = setInterval(() => {
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
}, 10);

ws.onclose = () => clearInterval(interval);
const util = {now: Date.now() };
setInterval(() => {
  Object.keys(hits).forEach(key => {
    let hit = hits[key];
    if (util.now - hit.time > 150) {
      hit = hits[key] = {val: 0, time: util.now};
      const coords =  key.split('-');
      const x = coords[0];
      const y = coords[1];
      colorPixel(x, y, hit.val);
    }
  });
}, 100);

setInterval(() => {
  console.log(JSON.stringify(hits, '', '  '));
}, 5000);
