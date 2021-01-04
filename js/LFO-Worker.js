const interval_time = 250
let frequency = 8
let timerID = null

// temp stuff
let noteInterval = 750
let nextNoteTime = 0

self.onmessage = function(event) {
  const cmd = event.data.cmd;

  if (cmd == "nextNoteTime") {
    nextNoteTime = event.data.nextNoteTime;
  } else if (cmd == "on") {
    console.log("starting lfo", event.data);

    nextNoteTime = event.data.initialTime + noteInterval;

    timerID = setInterval(
      () => postMessage({"cmd": "lfo-tick", "nextNoteTime": nextNoteTime, "noteInterval": noteInterval})
      , interval_time);

  } else if (cmd == "off") {
    console.log("stopping lfo");

    clearInterval(timerID);
    timerID = null;

  }
}

