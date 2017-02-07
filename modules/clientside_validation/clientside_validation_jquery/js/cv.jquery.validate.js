/**
 * @file
 * Attaches behaviors for the Clientside Validation jQuery module.
 */
(function ($, Drupal) {
  /**
   * Attaches jQuery validate behavoir to forms.
   *
   * @type {Drupal~behavior}
   *
   * @prop {Drupal~behaviorAttach} attach
   *  Attaches the outline behavior to the right context.
   */
  Drupal.behaviors.cvJqueryValidate = {
    attach: function (context) {
      $(context).find('form').validate();
    }
  };
})(jQuery, Drupal);
