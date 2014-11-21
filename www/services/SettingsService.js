var SettingsService;

SettingsService = (function() {
  function SettingsService() {
    this.hostUrl = '';
    this.contactToken = '';
  }

  SettingsService.prototype.initialize = function() {
    var deffered;
    deffered = $.Deferred();
    this.hostUrl = window.localStorage.getItem('hostUrl');
    this.contactToken = window.localStorage.getItem('contactToken');
    if (this.hostUrl === null) {
      this.hostUrl = 'https://chattycrow.com/api/v1';
    }
    if (this.contactToken === null) {
      this.contactToken = '';
    }
    deffered.resolve();
    return deffered.promise();
  };

  SettingsService.prototype.saveSettings = function(host, token) {
    this.hostUrl = host;
    this.contactToken = token;
    window.localStorage.setItem('hostUrl', this.hostUrl);
    return window.localStorage.setItem('contactToken', this.contactToken);
  };

  return SettingsService;

})();
