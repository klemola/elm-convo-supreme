(function (context) {
  var initMessage = {
    content : '',
    sentOn : 0,
    sentBy : ''
  }
  var appEl = context.querySelector('#app');
  var modalEl = context.querySelector('#modal');
  var usernameInputEl = context.querySelector('#username');
  var logInEl = context.querySelector('#logIn');
  var wsUrl = (location.protocol === 'https:' ? 'wss' : 'ws')
            + '://test-ws-chat.herokuapp.com'
  var socket = new WebSocket(wsUrl, 'echo-protocol');

  var app = Elm.embed(Elm.Main, appEl, {
    receiveMessage: initMessage,
    username: ''
  })

  socket.onopen = function (event) {
    app.ports.postMessage.subscribe(function(message) {
      socket.send(JSON.stringify(message));
    });
  };

  socket.onmessage = function(msg) {
    app.ports.receiveMessage.send(JSON.parse(msg.data));
  };

  logInEl.onclick = logIn;
  usernameInputEl.onkeyup = function(event) {
    if (event.keyCode == 13) {
      logIn();
    }
  };

  function logIn () {
    app.ports.username.send(usernameInputEl.value || 'WebUser');
    modalEl.setAttribute('class', 'hidden');
  }

})(document)
