var PushService;

PushService = (function() {
  function PushService() {}

  PushService.prototype.isRegistered = function() {
    return window.localStorage.getItem('pushId') !== null;
  };

  PushService.prototype.register = function() {
    var that;
    that = this;
    this.pushNotification = window.plugins.pushNotification;
    switch (device.platform.toLowerCase()) {
      case 'android':
        return this.pushNotification.register(that.success, that.fail, {
          "senderID": "286801227267",
          "ecb": "pushService.gcm_event"
        });
      case 'win32nt':
        break;
      default:
        return this.pushNotification.register(that.storePushId, that.fail, {
          "badge": "true",
          "sound": "true",
          "alert": "true",
          "ecb": "pushService.apn_event"
        });
    }
  };

  PushService.prototype.success = function(evt) {
    return null;
  };

  PushService.prototype.fail = function(evt) {
    return console.log(evt);
  };

  PushService.prototype.storePushId = function(id) {
    window.localStorage.setItem('pushId', id);
    return $('#log').html(id);
  };

  PushService.prototype.apn_event = function(e) {
    return alert(e.payload);
  };

  PushService.prototype.gcm_event = function(e) {
    switch (e.event) {
      case 'registered':
        return this.storePushId(e.regid);
      case 'message':
        return alert('message');
    }
  };

  return PushService;

})();
