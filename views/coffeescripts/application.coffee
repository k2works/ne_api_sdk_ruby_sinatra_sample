# イベントの抑制
$ ->
    $('#modal').on 'show.bs.modal', (e) ->
        if !$('#chkbtn').prop('checked')
            e.preventDefault()
            alert '表示抑制'

# AlertコンポーネントのAPIとイベント
$('#myalert').on 'close.bs.alert', (e) ->
    if (!confirm('閉じてよろしいですか？'))
        e.preventDefault()
