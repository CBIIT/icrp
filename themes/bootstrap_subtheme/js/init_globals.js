(function() {
  window['$'] = window['jQuery'];
})()

String.prototype.format = String.prototype.format ||
function () {
  "use strict";
  var str = this.toString();
  if (arguments.length) {
    var t = typeof arguments[0];
    var key;
    var args = ("string" === t || "number" === t) ?
      Array.prototype.slice.call(arguments)
      : arguments[0];

    for (key in args) {
      str = str.replace(new RegExp("\\{" + key + "\\}", "gi"), args[key]);
    }
  }
  return str;
};

/**
 * Calls a function after a user has been idle for a specified period of time
 * @param callback {Function} - The function to call
 * @param delay {number} - The delay (in milliseconds)
 */ 
function onIdle(callback, delay) {
  var timeoutId;
  var events = ["click", "mousedown", "mouseup", "focus", "blur", "keydown", "change", "mouseup", "click", "dblclick", "mousemove", "mouseover", "mouseout", "mousewheel", "keydown", "keyup", "keypress", "textInput", "touchstart", "touchmove", "touchend", "touchcancel", "resize", "scroll", "zoom", "focus", "blur", "select", "change", "submit", "reset"];
  
  function initTimeout() {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(function() {
      callback();
      events.forEach(function(event) {
        removeEventListener(event, initTimeout);
      });
    }, delay);
  }
  
  events.forEach(function(event) {
    addEventListener(event, initTimeout);
  });
  
  initTimeout();
}