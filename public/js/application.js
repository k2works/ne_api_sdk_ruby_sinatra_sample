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

}).call(this);
