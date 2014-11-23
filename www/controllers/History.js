var History;

History = (function() {
  function History(service) {
    this.service = service;
    this.el = $('<div/>');
    this.render;
  }

  History.prototype.render = function() {
    this.el.html(this.template(this.service));
    return this;
  };

  return History;

})();
