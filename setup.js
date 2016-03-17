(function (context, app) {
  var initMessage = {
    content : '',
    sentOn : 0,
    sentBy : ''
  }
  var appEl = context.querySelector('#app');
  var modalEl = context.querySelector('#modal');
  var usernameInputEl = context.querySelector('#username');
  var logInEl = context.querySelector('#logIn');
  var socket = new WebSocket("ws://localhost:3000", "echo-protocol");
  var user;

  var app = Elm.embed(Elm.Main, appEl, {
    receiveMessage: initMessage
  })

  socket.onopen = function (event) {
    app.ports.postMessage.subscribe(function(message) {
      socket.send(JSON.stringify(message));
    });
  };

  socket.onmessage = function(msg) {
    app.ports.receiveMessage.send(JSON.parse(msg.data));
  };

  logInEl.onclick = logIn
  usernameInputEl.onkeyup = function(event) {
    if (event.keyCode == 13) {
      logIn();
    }
  };

  function logIn () {
    user = usernameInputEl.value;
    modalEl.setAttribute('class', 'hidden');
  }

})(document)
