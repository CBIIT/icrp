window.$ = window.jQuery;

/**
 * Enables bootstrap tooltips
 */
function enableTooltips() {
  setTimeout(function() {
    $('[data-toggle="tooltip"]').tooltip({container: 'body'});
  }, 0);
}

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

(function($, Drupal, drupalSettings) {

  // conditionally shows/hides elements
  // based on show-if-user-roles="role"
  $('[show-if-user-roles]').each(function() {
    var el = $(this);
    var roles = el.attr('show-if-user-roles').split(',');
    var allowedRoles = drupalSettings.user.roles || [];
    var hasRole = _.intersection(roles, allowedRoles).length;
    hasRole ? el.show() : el.hide();
  })

  // sets tags with the data-count attribute to fetch counts from an api
  $('[data-count]').each(function() {
    var el = $(this);
    var key = el.data('count');
    $.get('/api/counts/' + key).then(function(response) {
      el.text(response.toLocaleString());
    });
  });

  // attaches cso example hrefs to each button
  if ($('a[id^="cso"]').length) {
    $.ajax('/api/examples/cso')
      .then(function(response) {
        for (key in response) {
          var element = document.getElementById(key);
          element.href = response[key];
        }
      });
  }

  // shows anchor targets inside modal dialogs using iframes
  // to set attributes on the iframe, use iframe-attr="value"
  // for example, iframe-class="class-a class-b"
  // we can also set the size of the modal using
  // 'modal-size'="small|large"
  $('[window-dialog]').click(function(event) {
    event.preventDefault();
    window.open(this.href, 'newwindow', 'width=600, height=400');
    return false;
  })


})(jQuery, Drupal, drupalSettings)
