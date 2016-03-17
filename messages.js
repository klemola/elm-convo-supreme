var initPorts = function (app) {
  var socket = new WebSocket("ws://localhost:3000", "echo-protocol");

  socket.onopen = function (event) {
    app.ports.postMessage.subscribe(function(message) {
      socket.send(JSON.stringify(message));
    });
  };

  socket.onmessage = function(msg) {
    app.ports.receiveMessage.send(JSON.parse(msg.data));
  };
};
