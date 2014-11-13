var History = function(service) {

  this.render = function() {
    this.$el.html(this.template());
    return this;
  }

  this.initialize = function() {
    this.$el = $('<div/>');
    this.render();
  }

  this.initialize();

}
