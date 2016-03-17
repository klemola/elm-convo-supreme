var initPorts = function (app) {
  app.ports.postMessage.subscribe(function(message) {
    app.ports.receiveMessage.send(message);
  });

  window.setInterval(function () {
    app.ports.receiveMessage.send({
      content: 'Hello',
      sentOn: new Date().getTime(),
      sentBy: 'Someone'
    });
  }, 10000)
};
