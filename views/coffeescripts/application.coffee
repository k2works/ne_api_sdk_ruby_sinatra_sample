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

# ツールチップの基本
$('#mybutton').tooltip()

# 表示非表示にする
$('#mybutton').tooltip('show')
$('#mybutton').tooltip('hide')

# ポップオーバー
$('[data-toggle=popover]').popover()

#動的にドロップダウンリストの要素を作る
menus = [
    'メニュー1'
    'メニュー2'
    'メニュー3'
]
menu_selected = {}

$ ->
    # ドロップダウンリストが開かれようとするときのイベント
    $('#mydropdown2').on 'show.bs.dropdown', (e) ->
        icon = undefined
        ul = $('#menulist2')
        ul.empty()
        # メニューを動的に作成する
        $.each menus, (i) ->
            icon = ''
            if menu_selected[i]
                icon = '<span class=\'glyphicon glyphicon-ok\'></span>'                
            ul.append '<li role=\'presentation\'>' + '<a href=\'#\' data-index=\'' + i + '\' tabindex=\'-1\'>' + icon + this + '</a></li>'
                
    # メニュー項目がクリックされたときのイベント
    $('#menulist2').on 'click', (e) ->
        index = $(e.target).attr('data-index')
        if index != undefined
            menu_selected[index] = if menu_selected[index] then false else true

# 処理中にクリックできないようにする
$ ->
    $('#mybutton2').on 'click', (e) ->
        btn = $(this)
        btn.button 'loading'
        setTimeout(->
            btn.button 'reset'            
        , 2000)

# ナビゲーションバーイベントを処理する
$('#mytab').on 'show.bs.tab', (e) ->
    fromTab = e.relatedTarget
    toTab = e.target

    if !confirm(fromTab.innerHtml + 'から' + toTab.innerHTML + 'に切り替えます。よろしいですか？')
        e.preventDefault()

# Collapseイベントを処理する
$ ->
    $('#closepanel').on 'hide.bs.collapse', (e) ->
        if !confirm('閉じてよろしいですか？')
            e.preventDefault()

# アクティブなメニュー項目に変わったことを把握する
$(document).on 'activate.bs.scrollspy', (e) ->
    alert e.target.nodeName

# カルーセルイベントを処理する
$ ->
    $('#mycarousel').on 'slide.bs.carousel', (e) ->
        if !confirm('切り替えても、よろしいですか？')
            e.preventDefault()
