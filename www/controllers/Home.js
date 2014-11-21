var Home;

Home = (function() {
  function Home(historyService) {
    this.service = historyService;
    this.el = $('<div/>');
    this.render;
  }

  Home.prototype.render = function() {
    this.el.html(this.template(this.service));
    return this;
  };

  return Home;

})();
