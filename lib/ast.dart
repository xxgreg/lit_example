library lit.ast;

List<String> templateParts(Node node) {
  var buffer = new StringBuffer();
  node._toTemplate(buffer);
  return buffer.toString().split(_placeholder);
}

List<String> bindings(Node node) {
  var expressions = [];
  node._toExpressions(expressions);
  return expressions;
}

const String _placeholder = r'{{{0.0}}}';

// perhaps only allow lower uppercase ascii and dash.
_checkValidChars(String s) => true;

//TODO
_escapeTagName(String n) => n;

//TODO
_escapeAttributeName(String n) => n.replaceAll('_', '-');

//TODO
_escapeAttributeValue(String v) => v;


abstract class Node {
  void _toTemplate(StringSink sink);

  void _toExpressions(List expressions);
}


abstract class AttributeNode implements Node {}


class AttributeBinding implements AttributeNode {
  AttributeBinding(this.expression);

  final String expression;

  String toString() => "(AttributeBinding $expression)";

  void _toTemplate(StringSink sink) => sink.write(_placeholder);

  void _toExpressions(List expressions) => expressions.add(expression);
}

class ElementBinding implements Node {
  ElementBinding(this.expression);

  final String expression;

  String toString() => "(ElementBinding $expression)";

  void _toTemplate(StringSink sink) => sink.write(_placeholder);

  void _toExpressions(List expressions) => expressions.add(expression);
}

class StringLiteral implements AttributeNode {
  StringLiteral(this.value);

  final String value;

  String toString() => "(StringLiteral $value)";

  void _toTemplate(StringSink sink) => sink.write(_escapeAttributeValue(value));

  void _toExpressions(List expressions) {}
}


class Tag implements Node {
  //TODO unmodifiable map and list.
  Tag(this.name, this.attributes, this.text, this.children) {
    _checkValidChars(name);
    attributes.forEach((k, _) => _checkValidChars(k));
  }

  final String name;
  final Map<String, AttributeNode> attributes;
  final AttributeNode text;
  final List<Node> children;

  String toString() => "(Tag $name $attributes $text $children)";

  void _toTemplate(StringSink sink) {
    var tag = _escapeTagName(name);
    sink.write('<$tag');
    attributes.forEach((k, v) {
      sink..write(' ')..write(_escapeAttributeName(k))..write('="');
      v._toTemplate(sink); // Escaping done in sub node.
      sink.write('"');
    });
    sink.write('>');
    if (text != null) text._toTemplate(sink);
    if (children != null) children.forEach((node) => node._toTemplate(sink));
    sink.write("</$tag>");
  }

  void _toExpressions(List expressions) {
    if (attributes != null) {
      attributes.forEach((k, node) =>
          node._toExpressions(expressions));
    }
    if (text != null) text._toExpressions(expressions);
    if (children != null) {
      children.forEach((node) =>
          node._toExpressions(expressions));
    }
  }
}

