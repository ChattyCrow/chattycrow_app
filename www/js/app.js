// We use an "Immediate Function" to initialize the application to avoid leaving anything behind in the global scope
(function () {

    /* ---------------------------------- Local Variables ---------------------------------- */
    var slider = new PageSlider($('.content'));

    /* -- Back button –- */
    var backButton = $('#backButton');

    /* -- Compile templates -- */
    Home.prototype.template = Handlebars.compile($('#home-tpl').html());
    About.prototype.template = Handlebars.compile($('#about-tpl').html());
    History.prototype.template = Handlebars.compile($('#history-tpl').html());
    Settings.prototype.template = Handlebars.compile($('#settings-tpl').html());

    var settingsService = new SettingsService();
    settingsService.initialize().done(function () {
      router.addRoute('', function() {
        slider.slidePage(new Home(settingsService).render().$el);
        backButton.hide();
      });

      router.addRoute('about', function() {
        slider.slidePage(new About(settingsService).render().$el);
        backButton.show();
      });

      router.addRoute('history', function() {
        slider.slidePage(new History(settingsService).render().$el);
        backButton.show();
      });

      router.addRoute('settings', function() {
        slider.slidePage(new Settings(settingsService).render().$el);
        backButton.show();
      });

      router.start();
    });

    /* --------------------------------- Event Registration -------------------------------- */
    document.addEventListener('deviceready', function () {
      StatusBar.overlaysWebView( false );
      StatusBar.backgroundColorByHexString('#ffffff');
      StatusBar.styleDefault();
      FastClick.attach(document.body);

      // Actions
      $('a.about').on('click', showAbout);
      $('a.exitApp').on('click', exitApp);

      // Hide splash
      if (navigator.notification) { // Override default HTML alert with native dialog
          window.alert = function (message) {
              navigator.notification.alert(
                  message,    // message
                  null,       // callback
                  "ChattyCrow", // title
                  'OK'        // buttonName
              );
          };
      }
    }, false);

    /* ---------------------------------- Local Functions ---------------------------------- */
    function showAbout() {
      alert('(c) Strnadj, 2014');
    }
    function exitApp() {
      navigator.app.exitApp();
    }
}());
