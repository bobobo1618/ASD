editor = 0

editorConfig =  {
    mode: 'markdown'
    lineNumbers: true
    theme: 'eclipse'
}

$('document').ready ()->
    editor = CodeMirror.fromTextArea document.getElementById 'bodyarea'
    for key, value of editorConfig
        editor.setOption key, value

switchMarkup = (markup)->
    label = document.getElementById 'markdownlabel'
    label.innerHTML = markup.display
    document.getElementById('markdownfield').value = markup.name
    editor.setOption 'mode', markup.name

submitData = ()->
    dataform = document.getElementById 'dataform'
    dataform.submit()