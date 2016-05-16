(function(context) {
  var scrollableElements = new Set();

  var appEl = context.querySelector('#app');
  var modalEl = context.querySelector('#modal');
  var usernameInputEl = context.querySelector('#username');
  var logInEl = context.querySelector('#logIn');

  var app = Elm.Main.embed(appEl);

  app.ports.scroll.subscribe(function(elementId) {
    scrollableElements.add(elementId);
    scroll(elementId);
  });

  logInEl.onclick = logIn;
  usernameInputEl.onkeyup = function(event) {
    if (event.keyCode == 13) {
      logIn();
    }
  };

  function logIn() {
    app.ports.username.send(usernameInputEl.value || 'WebUser');
    modalEl.setAttribute('class', 'hidden');
    scrollableElements.forEach(scroll)
  }

  function scroll(elementId) {
    var el = context.getElementById(elementId);
    if (el.children && el.children.length > 0) {
      el.children[el.children.length - 1].scrollIntoView();
    } else {
      el.scrollIntoView();
    }
  }

})(document);
