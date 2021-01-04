function getMIDIMessageType(data) {
  if(data[0] < 0xf0) {
    const typeCode = data[0] & 0xf0;
    switch(typeCode >> 4) {
      case 8: return 'NOTE OFF';
      case 9: return 'NOTE ON';
      case 10: return 'AFTER TOUCH';
      case 11: return 'CC';
      case 13: return 'PRESSURE';
      case 14: return 'PITCH BEND';
      default: return 'something else: ' + typeCode.toString(16);
    }
  } else {
    switch(data[0]) {
      case 0xf8: return 'CLOCK';
      case 0xfa: return 'START';
      case 0xfb: return 'CONTINUE';
      case 0xfc: return 'STOP';
      default: return 'something else: ' + typeCode.toString(16);
    }
  }
}

function midiMessageTypeToCode(midiMessageType) {
  switch(midiMessageType) {
    case 'NOTE OFF': return 128; //0x80
    case 'NOTE ON': return 144; //0x90
    case 'AFTER TOUCH': return 160;
    case 'CC': return 176;
    case 'PRESSURE': return 208;
    case 'PITCH BEND': return 224;
    default: return null;
  }
}

function getMIDIChannel(data) {
  return data[0] & 0x0f;
}

function mapIterator(fun, itt){
  const xs = [];
  itt.forEach(x => xs.push(fun(x)));
  return xs;
}
