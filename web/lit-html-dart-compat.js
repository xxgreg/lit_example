import {html, render} from './node_modules/lit-html/lib/lit-extended.js';

window.__lit_html = (strings, values) => html(strings, ...values);

window.__lit_render = (result, container) => render(result, container);
