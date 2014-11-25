var apn_event, backButton, changeTitleText, clearHistory, gcm_event, historyService, pushService, sendToChattyCrow, settingsService, showAbout, slider;

slider = new PageSlider($('.content'));

backButton = $('#backButton');

Home.prototype.template = Handlebars.compile($('#home-tpl').html());

About.prototype.template = Handlebars.compile($('#about-tpl').html());

History.prototype.template = Handlebars.compile($('#history-tpl').html());

Settings.prototype.template = Handlebars.compile($('#settings-tpl').html());

historyService = new HistoryService();

settingsService = new SettingsService();

pushService = new PushService(settingsService, historyService);

sendToChattyCrow = function(pushId, lat, lon, cb) {
  return $.ajax({
    url: ("" + settingsService.hostUrl + "/locations").replace('//', '/'),
    method: "POST",
    headers: {
      'Contact-Token': settingsService.contactToken
    },
    data: JSON.stringify({
      contact: pushId,
      latitude: lat,
      longitude: lon
    }),
    contentType: "application/json; charset=utf-8",
    dataType: 'json',
    success: function(data) {
      return cb(null, data);
    },
    error: function(data) {
      return cb(data, null);
    }
  });
};

apn_event = function(e) {
  console.log(e);
  return pushService.pushRecv(e);
};

gcm_event = function(e) {
  switch (e.event) {
    case 'registered':
      return pushService.storePushId(e.regid);
    case 'message':
      return pushService.pushRecv(e);
  }
};

showAbout = function(evt) {
  evt.preventDefault();
  return alert('(c) Strnadj, 2014');
};

clearHistory = function(evt) {
  evt.preventDefault();
  historyService.clearHistory();
  return alert('History cleared');
};

changeTitleText = function(text) {
  $('.text-second').html(text);
  $('.text-first').animate({
    opacity: 0.0
  }, 500);
  return $('.text-second').animate({
    opacity: 1.0
  }, 500, function() {
    $('.text-first').html(text);
    $('.text-first').css('opacity', '1.0');
    return $('.text-second').css('opacity', '0.0');
  });
};

settingsService.initialize().done(function() {
  router.addRoute('', function() {
    slider.slidePage(new Home(historyService, pushService).render().el);
    backButton.hide();
    return changeTitleText('ChattyCrow');
  });
  router.addRoute('about', function() {
    slider.slidePage(new About().render().el);
    backButton.show();
    return changeTitleText('About');
  });
  router.addRoute('history', function() {
    slider.slidePage(new History(historyService).render().el);
    backButton.show();
    return changeTitleText('History');
  });
  router.addRoute('settings', function() {
    slider.slidePage(new Settings(settingsService).render().el);
    backButton.show();
    return changeTitleText('Settings');
  });
  return router.start();
});

document.addEventListener('deviceready', function() {
  StatusBar.overlaysWebView(false);
  StatusBar.backgroundColorByHexString('#ffffff');
  StatusBar.styleDefault();
  FastClick.attach(document.body);
  $('#aboutBtn').on('click', showAbout);
  $('#clearHistory').on('click', clearHistory);
  if (navigator.notification) {
    return window.alert = function(message) {
      return navigator.notification.alert(message, null, 'ChattyCrow', 'OK');
    };
  }
}, false);
