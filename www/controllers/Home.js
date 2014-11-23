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
    this.el.on('click', '#signOutPush', function(evt) {
      evt.preventDefault();
      return pushService.unregister();
    });
    this.el.on('click', '#sendPosition', function(evt) {
      evt.preventDefault();
      window.plugins.spinnerDialog.show(null, 'Obtaining position ...');
      if (pushService.isRegistered()) {
        return navigator.geolocation.getCurrentPosition(function(position) {
          return sendToChattyCrow(pushService.getPushId(), position.coords.latitude, position.coords.longitude, function(err, suc) {
            if (err) {
              alert('Error while sending position');
            } else {
              alert('Position has been sent');
            }
            return window.plugins.spinnerDialog.hide();
          });
        }, function() {
          window.plugins.spinnerDialog.hide();
          return alert('Error getting location');
        });
      } else {
        return alert('Please register push ID');
      }
    });
    this.render;
  }

  Home.prototype.render = function() {
    this.el.html(this.template({
      history: this.historyService,
      pushRegistered: this.pushService.isRegistered()
    }));
    return this;
  };

  return Home;

})();
