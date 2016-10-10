

// draw input canvas
// allow click drawing?

// draw output canvas
// websocket handler.  clear out pixel after 500ms?


// window.addEventListener('load', () => {
const inputCanvas = document.querySelector('#input');
const inputContext = inputCanvas.getContext('2d');
const outputCanvas = document.querySelector('#output');
const outputContext = outputCanvas.getContext('2d');
inputContext.fillStyle = "rgba(0,0,0,255)";

let drawing = false;

//
const listener = e => {
  const x = e.layerX;
  const y = e.layerY;
  switch (e.type) {
    case 'mousedown':
      inputContext.fillRect(x, y, 1, 1);
      drawing = true;
      break;
    case 'mousemove':
      if (drawing) {
        inputContext.fillRect(x, y, 1, 1);
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
}, false);

const ws = new WebSocket('ws://localhost:15080/websocket');

let charge = 3.8;
// let threshold = 85;
const colorPixel = (x, y, hit) => {
  let alpha = 255;
  alpha = alpha * hit / 100;
  outputContext.fillStyle = "rgba(0,0,0,"+alpha+")";
  outputContext.fillRect(x, y, 10, 10);
};
const hits = {};
ws.onmessage = (message) => {
  const m = JSON.parse(message.data);
  const x = m[1] * 10;
  const y = m[0] * 10;
  const key = x + '-' + y;
  let hit = hits[key];
  hits[key] = hits[key] || 0;
  hit = hits[key] = Math.min(100, ++hits[key]);
  let alpha = 255;
  alpha = alpha * hit / 100;
  outputContext.fillStyle = "rgba(0,0,0,"+alpha+")";
  outputContext.fillRect(x, y, 10, 10);
};
let interval = setInterval(() => {
  const height = inputCanvas.height;
  const width = inputCanvas.width;
  const data = inputContext.getImageData(
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

  // websocket call
  if (inputs.length) {
    inputs = _.shuffle(inputs);
    ws.send(JSON.stringify(inputs));
  }
  //console.log('inputs', inputs);

}, 10);

ws.onclose = () => clearInterval(interval);

setInterval(() => {
  Object.keys(hits).forEach(key => {
    let hit = hits[key];
    hit = hits[key]--;
    const coords =  key.split('-');
    const x = coords[0];
    const y = coords[1];
    colorPixel(x, y, hit);
  });
}, 100);
// }, false);
