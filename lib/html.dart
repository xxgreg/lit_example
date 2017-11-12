library lit.html;

import 'js_interop.dart' show TemplateResult;

export 'annotation.dart' show lit;
export 'js_interop.dart' show TemplateResult, render, html$js;

TemplateResult html(String template) {
  throw "This should never be called - if it was called then the code generation step hasn't run.";
}
