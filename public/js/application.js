(function() {
  $(function() {
    return $('#modal').on('show.bs.modal', function(e) {
      if (!$('#chkbtn').prop('checked')) {
        e.preventDefault();
        return alert('表示抑制');
      }
    });
  });

}).call(this);
