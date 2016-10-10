

// draw input canvas
// allow click drawing?

// draw output canvas
// websocket handler.  clear out pixel after 500ms?


// window.addEventListener('load', () => {
const inputCanvas = document.querySelector('#input');
const inputContext = inputCanvas.getContext('2d');
const outputCanvas = document.querySelector('#output');
const outputContext = outputCanvas.getContext('2d');
outputContext.fillStyle = "rgba(0,0,0,255)";
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

let charge = 10;
const clears = {};
ws.onmessage = (message) => {
  const m = JSON.parse(message.data);
  const x = m[1] * 10;
  const y = m[0] * 10;
  outputContext.fillRect(x, y, 10, 10);
  const key = x + '-' + y;
  let clear = clears[key];
  if (!clear) {
    clear = clears[key] = _.debounce(() => {
      outputContext.clearRect(x, y, 10, 10);
    }, 2000);
  }
  clear();
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
    try {
      ws.send(JSON.stringify(inputs))
    } catch (e) {
      console.error(e);
      clearInterval(interval);
    }
  }
  //console.log('inputs', inputs);

}, 50);

// }, false);
