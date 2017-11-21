$(function() {

  reset();

  $('#load').click(load);
  $('#reset').click(reset);
  $('#input-file').change(validate);

  function validate() {
    var filename = $('#input-file').val();
    $('#load').prop('disabled', !/.csv$/.test(filename));
  }

  function load() {
    $('#input-file').parse({
      config: {
        complete: callEndpoint,
        skipEmptyLines: true,
      }
    });
  }

  function callEndpoint(fileContents) {
    fileContents.data.shift();
    $.post('/api/collaborators/import', JSON.stringify(fileContents.data))
      .done(function() {
        $('#status-alert')
          .removeClass('alert-warning')
          .addClass('alert-success');
      })
      .fail(function() {
        $('#status-alert')
          .removeClass('alert-success')
          .addClass('alert-warning');
      })
      .always(function(response) {
        $('#status-alert').show();
        $('#status-message').html(response);
      });
  }

  function reset() {
    $('#load').prop('disabled', true);
    $('#input-file').val('');
    $('#status-alert').hide();
    $('#status-message').html('');
  }

  // replace data-dismiss with data-hide
  $('[data-hide]').click(function(event) {
    var selector = $(event.target)
      .closest('[data-hide]')
      .attr('data-hide');
    $(selector).hide();
  });
});