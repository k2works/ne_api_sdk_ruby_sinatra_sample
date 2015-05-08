(function() {
  var menu_selected, menus;

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

  menus = ['メニュー1', 'メニュー2', 'メニュー3'];

  menu_selected = {};

  $(function() {
    $('#mydropdown2').on('show.bs.dropdown', function(e) {
      var icon, ul;
      icon = void 0;
      ul = $('#menulist2');
      ul.empty();
      return $.each(menus, function(i) {
        icon = '';
        if (menu_selected[i]) {
          icon = '<span class=\'glyphicon glyphicon-ok\'></span>';
        }
        return ul.append('<li role=\'presentation\'>' + '<a href=\'#\' data-index=\'' + i + '\' tabindex=\'-1\'>' + icon + this + '</a></li>');
      });
    });
    return $('#menulist2').on('click', function(e) {
      var index;
      index = $(e.target).attr('data-index');
      if (index !== void 0) {
        return menu_selected[index] = menu_selected[index] ? false : true;
      }
    });
  });

  $(function() {
    return $('#mybutton2').on('click', function(e) {
      var btn;
      btn = $(this);
      btn.button('loading');
      return setTimeout(function() {
        return btn.button('reset');
      }, 2000);
    });
  });

}).call(this);
