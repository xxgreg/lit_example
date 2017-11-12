library lit.daml;

import 'js_interop.dart' show TemplateResult;

export 'annotation.dart' show lit;
export 'js_interop.dart' show TemplateResult, render, html$js;

const _message = r"This should never be called - if it was called then the code generation step hasn't run.";

TemplateResult daml(LitNode node) => throw _message;

class LitNode {}

T $<T>(dynamic expression) => throw _message;

// TODO generate a bunch of these functions from html definitions.

LitNode span({String id, String text, List<LitNode> children}) => throw _message;

LitNode div({String text, List<LitNode> children, String id, String style}) => throw _message;

LitNode input({String id, String value, Function on_input}) => throw _message;

LitNode button({String on_click, String text}) => throw _message;
