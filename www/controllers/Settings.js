var Settings;

Settings = (function() {
  function Settings(service) {
    var that;
    this.service = service;
    this.el = $('<div/>');
    that = this;
    this.el.on('click', '#saveSettings', function(evt) {
      evt.preventDefault();
      return that.saveSettings();
    });
    this.el.on('click', '#scanQRCode', function(evt) {
      evt.preventDefault();
      return cordova.plugins.barcodeScanner.scan(function(result) {
        if (result.text.length > 0) {
          $('#contactToken').val(result.text);
          return alert('Success');
        } else {
          return alert('Error while scanning');
        }
      }, function(error) {
        return alert("Error while scanning " + error);
      });
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
