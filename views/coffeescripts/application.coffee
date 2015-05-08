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

# モーダルダイアログボックスを表示／非表示にする
$('#mymodal').modal('show')
$('#mymodal').modal('hide')

# 閉じられようとするときのイベントを処理する
$('#mymodal').on 'hide.bs.modal', (e) ->
    if (!confirm('閉じてよろしいですか？'))
        e.preventDefault()
