var PushService;

PushService = (function() {
  function PushService(settings, history) {
    this.settingsService = settings;
    this.historyService = history;
  }

  PushService.prototype.getPushId = function() {
    return window.localStorage.getItem('pushId');
  };

  PushService.prototype.isRegistered = function() {
    return this.getPushId() !== null;
  };

  PushService.prototype.unregister = function() {
    var that;
    that = this;
    window.plugins.pushNotification.unregister(that.success, that.fail);
    window.localStorage.removeItem('pushId');
    $('#signOutPush').hide();
    $('#signInPush').show();
    return alert('Sucessfully unregistered');
  };

  PushService.prototype.register = function() {
    var that;
    that = this;
    window.plugins.spinnerDialog.show(null, 'Registering Push Id');
    this.pushNotification = window.plugins.pushNotification;
    switch (device.platform.toLowerCase()) {
      case 'android':
        return this.pushNotification.register(that.success, that.fail, {
          "senderID": "286801227267",
          "ecb": "gcm_event"
        });
      case 'win32nt':
        break;
      default:
        return this.pushNotification.register(that.storePushId, that.fail, {
          "badge": "true",
          "sound": "true",
          "alert": "true",
          "ecb": "apn_event"
        });
    }
  };

  PushService.prototype.success = function(evt) {
    return null;
  };

  PushService.prototype.fail = function(evt) {
    return console.log(evt);
  };

  PushService.prototype.pushRecv = function(push) {
    this.historyService.addPush(push);
    return alert('Push recieved');
  };

  PushService.prototype.storePushId = function(id) {
    window.localStorage.setItem('pushId', id);
    return sendToChattyCrow(id, 0.0, 0.0, function(err, data) {
      window.plugins.spinnerDialog.hide();
      if (err) {
        window.localStorage.removeItem('pushId');
        return alert('Registration fail');
      } else {
        alert('Registration success');
        $('#signOutPush').show();
        return $('#signInPush').hide();
      }
    });
  };

  return PushService;

})();
