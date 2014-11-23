var HistoryService;

HistoryService = (function() {
  function HistoryService() {
    this.pushes = window.localStorage.getItem('pushes');
    if (this.pushes === null) {
      this.pushes = [];
    } else {
      this.pushes = JSON.parse(this.pushes);
    }
    this.pushesCount = this.pushes.length;
  }

  HistoryService.prototype.clearHistory = function() {
    this.pushes = [];
    this.pushesCount = 0;
    window.localStorage.setItem('pushes', JSON.stringify(this.pushes));
    $('#pushCount').html(this.pushesCount);
    return window.location = '#';
  };

  HistoryService.prototype.addPush = function(content) {
    var d;
    d = new Date();
    this.pushes.unshift({
      date: "" + (d.getDate()) + "." + (d.getMonth()) + "." + (d.getFullYear()) + " " + (d.getHours()) + ":" + (d.getMinutes()),
      message: JSON.stringify(content, void 0, 2)
    });
    window.localStorage.setItem('pushes', JSON.stringify(this.pushes));
    this.pushesCount++;
    return $('#pushCount').html(this.pushesCount);
  };

  return HistoryService;

})();
