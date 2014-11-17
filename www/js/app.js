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
        changeTitleText('ChattyCrow');
      });

      router.addRoute('about', function() {
        slider.slidePage(new About(settingsService).render().$el);
        backButton.show();
        changeTitleText('About');
      });

      router.addRoute('history', function() {
        slider.slidePage(new History(settingsService).render().$el);
        backButton.show();
        changeTitleText('History');
      });

      router.addRoute('settings', function() {
        slider.slidePage(new Settings(settingsService).render().$el);
        backButton.show();
        changeTitleText('Settings');
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
    function showAbout(evt) {
      evt.preventDefault();
      alert('(c) Strnadj, 2014');
    }
    function exitApp(evt) {
      evt.preventDefault();
      navigator.app.exitApp();
    }
    function changeTitleText(text) {
      $('.text-second').html(text);
      // start fade in / fade out
      $('.text-first').animate({ opacity: 0.0 }, 500);
      $('.text-second').animate({ opacity: 1.0 }, 500, function() {
        $('.text-first').html(text);
        $('.text-first').css('opacity', '1.0');
        $('.text-second').css('opacity', '0.0');
      });
    }
}());
