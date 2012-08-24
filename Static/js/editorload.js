var editor, editorConfig, submitData, switchMarkup;

editor = 0;

editorConfig = {
  mode: 'markdown',
  lineNumbers: true,
  theme: 'eclipse'
};

$('document').ready(function() {
  var key, value, _results;
  editor = CodeMirror.fromTextArea(document.getElementById('bodyarea'));
  _results = [];
  for (key in editorConfig) {
    value = editorConfig[key];
    _results.push(editor.setOption(key, value));
  }
  return _results;
});

switchMarkup = function(markup) {
  var label;
  label = document.getElementById('markdownlabel');
  label.innerHTML = markup.display;
  document.getElementById('markdownfield').value = markup.name;
  return editor.setOption('mode', markup.name);
};

submitData = function() {
  var dataform;
  dataform = document.getElementById('dataform');
  return dataform.submit();
};
