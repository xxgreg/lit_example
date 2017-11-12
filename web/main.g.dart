// GENERATED CODE - DO NOT MODIFY BY HAND

part of main;

// **************************************************************************
// Generator: LitTemplateGenerator
// **************************************************************************

// (Tag div {style: (StringLiteral margin-top: 20px)} null [(Tag div {} (AttributeBinding entry.name) null), (Tag input {id: (AttributeBinding entry.id), value: (AttributeBinding entry.value), on_input: (AttributeBinding updateEntry)} null null)])

const _entryInputDaml$templateParts = const [
  '<div style="margin-top: 20px"><div>',
  '</div><input id="',
  '" value="',
  '" on-input="',
  '"></input></div>'
];

TemplateResult entryInputDaml(Entry entry) => html$js(
    _entryInputDaml$templateParts,
    [entry.name, entry.id, entry.value, updateEntry]);

// (Tag div {} null [(Tag div {style: (StringLiteral margin: 20px)} null [(Tag input {id: (StringLiteral add-name), value: (AttributeBinding nextName), on_input: (AttributeBinding updateName)} null null), (Tag button {on_click: (AttributeBinding addEntry)} (StringLiteral Add) null)]), (Tag div {style: (StringLiteral margin: 20px)} null [(ElementBinding entries.keys.map((k) => entryInputDaml(entries[k])).toList())])])

const _formDaml$templateParts = const [
  '<div><div style="margin: 20px"><input id="add-name" value="',
  '" on-input="',
  '"></input><button on-click="',
  '">Add</button></div><div style="margin: 20px">',
  '</div></div>'
];

TemplateResult formDaml() => html$js(_formDaml$templateParts, [
      nextName,
      updateName,
      addEntry,
      entries.keys.map((k) => entryInputDaml(entries[k])).toList()
    ]);

const _entryInputHtml$templateParts = const [
  '  <div style="margin-top: 20px">\n    <div>',
  '</div>\n    <input id="',
  '" value="',
  '" on-input="',
  '">\n  </div>\n'
];

TemplateResult entryInputHtml(Entry entry) => html$js(
    _entryInputHtml$templateParts,
    [entry.name, entry.id, entry.value, updateEntry]);

const _formHtml$templateParts = const [
  '  <div style="margin: 20px">\n    <input id="add-name" value="',
  '" on-input="',
  '">\n    <button on-click="',
  '">Add</button>\n  </div>\n  <div style="margin: 20px;">\n    ',
  '\n  </div>\n'
];

TemplateResult formHtml() => html$js(_formHtml$templateParts, [
      nextName,
      updateName,
      addEntry,
      entries.keys.map((k) => entryInputDaml(entries[k])).toList()
    ]);
