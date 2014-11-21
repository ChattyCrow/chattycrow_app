var Home;

Home = (function() {
  function Home(historyService, pushService) {
    this.historyService = historyService;
    this.pushService = pushService;
    this.el = $('<div/>');
    this.el.on('click', '#signInPush', function(evt) {
      evt.preventDefault();
      if (pushService.isRegistered()) {
        return alert('Already registered');
      } else {
        return pushService.register();
      }
    });
    this.render;
  }

  Home.prototype.render = function() {
    this.el.html(this.template(this.historyService));
    return this;
  };

  return Home;

})();
