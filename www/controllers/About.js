var About;

About = (function() {
  function About() {
    this.el = $('<div/>');
    this.render;
  }

  About.prototype.render = function() {
    this.el.html(this.template());
    return this;
  };

  return About;

})();
