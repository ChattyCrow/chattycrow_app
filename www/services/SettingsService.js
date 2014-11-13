var SettingsService = function () {

  // Persist informations
  var hostUrl, contactToken;

  this.initialize = function() {
    var deferred = $.Deferred();

    // Get Data from local storage!
    hostUrl = window.localStorage.getItem("hostUrl");
    contactToken = window.localStorage.getItem("contactToken");

    // If undefined set defaults
    if (hostUrl == null) {
      hostUrl = "https://chattycrow.com/api/v1/";
    }
    if (contactToken == null) {
      contactToken = "";
    }

    deferred.resolve();
    return deferred.promise();
  }

  this.saveSettings = function(host, token) {
    // Set variables to later-use
    hostUrl = host;
    contactToken = token;

    // Persist in local storage
    window.localStorage.setItem("hostUrl", hostUrl);
    window.localStorage.setItem("contactToken", contactToken);
  }

  this.getHostUrl = function() {
    return hostUrl;
  }

  this.getContactToken = function() {
    return contactToken;
  }
}
