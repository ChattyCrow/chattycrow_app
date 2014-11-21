var Settings;

Settings = (function() {
  function Settings(service) {
    var that;
    this.service = service;
    this.el = $('<div/>');
    that = this;
    this.el.on('click', '#saveSettings', function() {
      return that.saveSettings();
    });
    this.render;
  }

  Settings.prototype.render = function() {
    this.el.html(this.template(this.service));
    return this;
  };

  Settings.prototype.saveSettings = function() {
    this.service.saveSettings($('#serverHost').val(), $('#contactToken').val());
    window.location = '#';
    return alert('Settings was saved');
  };

  return Settings;

})();
