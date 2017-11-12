library lit.code_generator_html;

import 'package:lit_example/ast.dart';
import 'package:analyzer/dart/ast/ast.dart' hide StringLiteral;

String buildHtml(String functionName, String params, Expression e) {
  if (e is! StringInterpolation) {
    throw "Expected StringInterpolation got, ${e.runtimeType}.";
  }

  var fname = functionName.substring(1);

  var elements = (e as StringInterpolation).elements;

  var parts = elements
      .where((e) => e is InterpolationString)
      .map((e) => e as InterpolationString)
      .map((s) => s.value).toList();

  var expressions = elements
      .where((e) => e is InterpolationExpression)
      .map((e) => e as InterpolationExpression)
      .map((e) => e.expression.toSource());

  return '''
  
  const _$fname\$templateParts = const [ ${parts.map(_quotedString).join(", ")} ];

TemplateResult $fname$params => html\$js(_$fname\$templateParts, [${expressions
      .join('\, ')}]);

  ''';
}

String _quotedString(String string) {
  var s = string.replaceAll("'", r"\'").replaceAll("\n", r"\n");
  return "'$s'";
}
