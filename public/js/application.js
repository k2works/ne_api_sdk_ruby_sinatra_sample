(function() {
  $(function() {
    return $('#modal').on('show.bs.modal', function(e) {
      if (!$('#chkbtn').prop('checked')) {
        e.preventDefault();
        return alert('表示抑制');
      }
    });
  });

  $('#myalert').on('close.bs.alert', function(e) {
    if (!confirm('閉じてよろしいですか？')) {
      return e.preventDefault();
    }
  });

  $('#mymodal').modal('show');

  $('#mymodal').modal('hide');

  $('#mymodal').on('hide.bs.modal', function(e) {
    if (!confirm('閉じてよろしいですか？')) {
      return e.preventDefault();
    }
  });

  $('#mybutton').tooltip();

  $('#mybutton').tooltip('show');

  $('#mybutton').tooltip('hide');

  $('[data-toggle=popover]').popover();

}).call(this);
