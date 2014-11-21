var backButton, changeTitleText, exitApp, historyService, pushService, settingsService, showAbout, slider;

slider = new PageSlider($('.content'));

backButton = $('#backButton');

Home.prototype.template = Handlebars.compile($('#home-tpl').html());

About.prototype.template = Handlebars.compile($('#about-tpl').html());

History.prototype.template = Handlebars.compile($('#history-tpl').html());

Settings.prototype.template = Handlebars.compile($('#settings-tpl').html());

historyService = new HistoryService();

settingsService = new SettingsService();

pushService = new PushService();

showAbout = function(evt) {
  evt.preventDefault();
  return alert('(c) Strnadj, 2014');
};

exitApp = function(evt) {
  evt.preventDefault();
  return navigator.app.exitApp();
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
  $('a.about').on('click', showAbout);
  $('a.exitApp').on('click', exitApp);
  if (navigator.notification) {
    return window.alert = function(message) {
      return navigator.notification.alert(message, null, 'ChattyCrow', 'OK');
    };
  }
}, false);
