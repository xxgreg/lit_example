library lit.code_generator_daml;

import 'package:lit_example/ast.dart';
import 'package:analyzer/dart/ast/ast.dart' hide StringLiteral;


String buildDaml(String functionName, String params, Expression e) {

  if (e is! MethodInvocation) {
    throw "Expected MethodInvocation got, ${e.runtimeType}.";
  }

  var fname = functionName.substring(1);
  var invocation = e as MethodInvocation;
  var root = tag(invocation);
  var parts = templateParts(root);
  var expressions = bindings(root);

  return '''
  
  // ${root.toString()}
  
const _$fname\$templateParts = const [ ${parts.map(_quotedString).join(", ")} ];

TemplateResult $fname$params => html\$js(_$fname\$templateParts, [${expressions
      .join('\, ')}]);

''';
}

String _quotedString(String string) {
  var s = string.replaceAll("'", r"\'").replaceAll("\n", r"\n");
  return "'$s'";
}

Tag tag(MethodInvocation invocation) {
  var id = invocation.function as SimpleIdentifier;
  var name = id.token.lexeme;

  // name -> Expression
  var args = new Map<String, Expression>.fromIterable(
      invocation.argumentList.arguments,
      key: argumentName,
      value: argumentValue);

  var children = args.remove(_children);
  var text = attributeNode(args.remove(_text));
  var attrMap = attrMapLiteral(args.remove(_attrs));

  // In dart2 we get map.map()! yay.
  var attrs = <String, AttributeNode>{};
  args.forEach((k, v) {
    attrs[k] = attributeNode(v);
  });
  if (attrMap != null) attrs.addAll(attrMap);

  return new Tag(name, attrs, text, childrenList(children));
}

const String _children = "children";
const String _attrs = "attrs";
const String _text = "text";
const String _bind = r'$';


String argumentName(Expression argument) =>
    (argument as NamedExpression).element.name;


String invocationName(MethodInvocation invocation) {
  var id = invocation.function as SimpleIdentifier;
  return id.token.lexeme;
}


ElementBinding binding(MethodInvocation invocation) {
  if (invocationName(invocation) != _bind) throw "Expected binding $_bind()";
  var e = invocation.argumentList.arguments.first;
  return new ElementBinding(e.toSource());
}


AttributeBinding stringBinding(MethodInvocation invocation) {
  if (invocationName(invocation) != _bind) throw "Expected binding $_bind().";
  var e = invocation.argumentList.arguments.first;
  return new AttributeBinding(e.toSource());
}


Expression argumentValue(Expression argument) {
  if (argument is NamedExpression) {
    return argument.expression;
  } else {
    throw "Expected NamedExpression, got ${argument.runtimeType}.";
  }
}


String toString(Expression e) {
  if (e is SimpleStringLiteral) {
    return e.value;
  } else {
    throw "Expected string literal, got ${e.runtimeType}.";
  }
}


StringLiteral stringLiteral(Expression e) {
  if (e is SimpleStringLiteral) {
    return new StringLiteral(e.value);
  } else {
    throw "Expected string literal.";
  }
}


AttributeNode attributeNode(Expression e) {
  if (e == null) {
    return null;
  } else if (e is SimpleStringLiteral) {
    return stringLiteral(e);
  } else if (e is MethodInvocation) {
    return stringBinding(e);
  } else {
    throw "Unexpected ast node ${e.runtimeType}.";
  }
}


Map<String, AttributeNode> attrMapLiteral(Expression e) {
  if (e == null) {
    return null;
  } else if (e is MapLiteral) {
    return new Map<String, AttributeNode>.fromIterable(
        e.entries, key: (e) => toString(e.key), value: (e) => attributeNode(e));
  } else {
    throw "Expected map literal, got ${e.runtimeType}.";
  }
}


Node node(Expression e) {
  if (e is SimpleStringLiteral) {
    return stringLiteral(e);
  } else if (e is MethodInvocation) {
    return invocationName(e) == _bind ? binding(e) : tag(e);
  } else {
    throw "Expected string literal or method invocation, got ${e.runtimeType}.";
  }
}

List<Node> childrenList(Expression e) {
  if (e == null) {
    return null;
  } else if (e is ListLiteral) {
    return e.elements.map(node).toList();
  } else {
    throw "Expected list literal, got ${e.runtimeType}.";
  }
}

