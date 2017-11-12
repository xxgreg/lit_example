@JS()
library lit.js_interop;

import 'dart:html';
import "package:js/js.dart";

@JS()
@anonymous
abstract class TemplateResult {}

@JS()
external TemplateResult __lit_html(List<String> strings, List<Object> values);

@JS()
external void __lit_render(TemplateResult result, HtmlElement container);


TemplateResult html$js(List<String> strings, List<Object> values) =>
    __lit_html(strings, values);


void render(TemplateResult result, HtmlElement container) =>
    __lit_render(result, container);
