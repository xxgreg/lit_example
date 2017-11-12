library lit.code_generator;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:lit_example/annotation.dart' show Lit;
import 'package:lit_example/code_generator_daml.dart' show buildDaml;
import 'package:lit_example/code_generator_html.dart' show buildHtml;

import 'package:build/build.dart';
import 'package:analyzer/dart/ast/ast.dart' hide StringLiteral;


class LitTemplateGenerator extends GeneratorForAnnotation<Lit> {
  final bool forClasses, forLibrary;

  const LitTemplateGenerator({this.forClasses: true, this.forLibrary: false});

  @override
  Future<String> generateForAnnotatedElement(Element element,
      ConstantReader annotation, BuildStep buildStep) async {
    //TODO correctly throw message if annotation isn't added on a function.
    // Or perhaps just silently ignore this?
    assert(element.kind == ElementKind.FUNCTION);

    return buildTemplate(element as FunctionElement);
  }

  @override
  String toString() => 'LitTemplateGenerator';
}


String buildTemplate(FunctionElement f) {
  //TODO error messages if not the expected type of function.

  var decl = f.computeNode();
  var body = decl.functionExpression.body as ExpressionFunctionBody;

  var fname = decl?.name?.name;

  if (!fname.startsWith('_')) {
    throw "Template function name must start with underscore.";
  }

  var params = _parameterList(f);
  var invocation = body.expression as MethodInvocation;

  var name = invocationName(invocation);
  if (name == _daml) {
    return buildDaml(fname, params, invocation.argumentList.arguments.first);
  } else if (name == _html) {
    return buildHtml(fname, params, invocation.argumentList.arguments.first);
  } else {
    throw "Expected daml(...) or html(...), got: $name.";
  }
}

String invocationName(MethodInvocation invocation) {
  var id = invocation.function as SimpleIdentifier;
  return id.token.lexeme;
}

final RegExp _parens = new RegExp(r"\(.+\)");


//FIXME This is an ugly hack, find out how to get this properly.
String _parameterList(FunctionElement f) {
  var s = f.toString();
  int i = s.indexOf(r'(');
  int j = s.lastIndexOf(r')');
  //TODO error handling.
  return s.substring(i, j + 1);
}

const String _daml = "daml";
const String _html = "html";

