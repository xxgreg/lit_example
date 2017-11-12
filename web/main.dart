library main;

import 'dart:html';
import 'dart:math';
import 'package:lit_example/daml.dart';
import 'package:lit_example/html.dart';

part 'main.g.dart';

class Entry {
  Entry(this.id, this.name, this.value);

  factory Entry.randomId(String name, String value) =>
      new Entry(new Random().nextInt(2 ^ 32), name, value);

  final int id;
  final String name;
  final String value;

  Entry withValue(String value) => new Entry(id, name, value);
}

var initial = new Entry.randomId("Foo", "Bar");

var nextName = "";

var entries = <int, Entry>{initial.id: initial};

bool _needsRender = true;

void invalidate() {
  _needsRender = true;
  window.requestAnimationFrame((e) {
    _needsRender = false;
    // Using the daml templates, switch this to formHtml to use the HTML templates.
    render(formDaml(), document.body);
  });
}

void updateEntry(Event e) {
  var input = e.target as InputElement;
  var id = int.parse(input.id);
  var entry = entries[id].withValue(input.value);
  entries[id] = entry;
  invalidate();
}

void addEntry(Event e) {
  var entry = new Entry.randomId(nextName, "");
  entries[entry.id] = entry;
  invalidate();
}

//FIXME get closures to work: on-input"${(e) => nextName = e.target.value}"
void updateName(Event e) {
  nextName = (e.target as InputElement).value;
}

void main() {
  invalidate();
}

@lit
TemplateResult _entryInputDaml(Entry entry) =>
    daml(
        div(style: "margin-top: 20px", children: [
          div(text: $(entry.name)),
          input(
              id: $(entry.id), value: $(entry.value), on_input: $(updateEntry)),
        ]));

@lit
TemplateResult _formDaml() =>
    daml(div(children: [
      div(style: "margin: 20px", children: [
        input(id: "add-name", value: $(nextName), on_input: $(updateName)),
        button(on_click: $(addEntry), text: "Add"),
      ]),
      div(style: "margin: 20px", children: [
        $(entries.keys.map((k) => entryInputDaml(entries[k])).toList())
      ]),
    ]));

@lit
TemplateResult _entryInputHtml(Entry entry) =>
    html('''
  <div style="margin-top: 20px">
    <div>${entry.name}</div>
    <input id="${entry.id}" value="${entry.value}" on-input="$updateEntry">
  </div>
''');

@lit
TemplateResult _formHtml() =>
    html('''
  <div style="margin: 20px">
    <input id="add-name" value="$nextName" on-input="$updateName">
    <button on-click="$addEntry">Add</button>
  </div>
  <div style="margin: 20px;">
    ${entries.keys.map((k) => entryInputDaml(entries[k])).toList()}
  </div>
''');
