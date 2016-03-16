var initPorts = function (app) {
  window.setInterval(function () {
    app.ports.receiveMessage.send({
      content: 'Hello',
      sentOn: new Date().getTime(),
      sentBy: 'Someone'
    });
  }, 10000)
};
