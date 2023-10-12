// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

import './src/jquery-global';


$(document).ready(function() {
  $(document).on('click', '.add_fields', function (event) {
    console.log('aqui');
    event.preventDefault();
    var id = $(this).data('id');
    var fields = $('#' + id + ' .fields:first').clone();
    fields.find('input').val('');
    $('#' + id).append(fields);
    window.location.reload();
  });
  
  $(document).on('click', '.remove_fields', function (event) {
    event.preventDefault();
    $(this).closest('.fields').remove();
  });
});
