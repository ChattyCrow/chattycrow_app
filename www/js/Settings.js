var Settings = function(settingsService) {

  this.render = function() {
    this.$el.html(this.template({hostUrl: settingsService.getHostUrl() , contactToken: settingsService.getContactToken() }));
    return this;
  }

  /* -- Save settings -- */
  this.saveSettings = function() {
    settingsService.saveSettings($('#serverHost').val(), $('#contactToken').val());
    window.location = "#";
    alert('Settings was saved');
  }

  this.initialize = function() {
    this.$el = $('<div/>');
    this.$el.on('click', '#saveSettings', this.saveSettings);
    this.render();
  }

  this.initialize();

}
