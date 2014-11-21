var History;

History = (function() {
  function History(service) {
    this.service = service;
    this.el = $('<div/>');
    this.render;
  }

  History.prototype.render = function() {
    this.el.html(this.template());
    return this;
  };

  return History;

})();
