# イベントの抑制
$ ->
    $('#modal').on 'show.bs.modal', (e) ->
        if !$('#chkbtn').prop('checked')
            e.preventDefault()
            alert '表示抑制'
