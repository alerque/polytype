import { EditorView, lineNumbers } from "@codemirror/view";
import { EditorState } from "@codemirror/state";
import { syntaxHighlighting, defaultHighlightStyle } from "@codemirror/language";
import { css } from "@codemirror/lang-css";
import { html } from "@codemirror/lang-html";
import { javascript } from "@codemirror/lang-javascript";
import { markdown } from "@codemirror/lang-markdown";
import { xml } from "@codemirror/lang-xml";
import { yaml } from "@codemirror/lang-yaml";
import { latex } from "codemirror-lang-latex";
import { typst } from "codemirror-lang-typst";

const languageMap = {
	// Official CodeMirror languages
	css: css(),
	html: html(),
	javascript: javascript(),
	markdown: markdown(),
	xml: xml(),
	yaml: yaml(),
	// Unofficial 3rd party languages
	latex: latex(),
	typst: typst(),
	// Aliases to near-matches
	pagedjs: html(),
	sile: latex(),
	weasyprint: html(),
	xelatex: latex(),
};

window.initCodeMirror = function (element, content, language) {
	let polyTheme = EditorView.baseTheme({
		"&light": {
			backgroundColor: "#fff",
		},
		"&dark": {
			backgroundColor: "#000",
		},
	});

	const extensions = [
		EditorState.readOnly.of(true),
		polyTheme,
		lineNumbers(),
		syntaxHighlighting(defaultHighlightStyle),
		languageMap[language] || [],
	];

	let div = document.createElement("div");
	div.className = element.className;
	element.replaceWith(div);

	new EditorView({
		state: EditorState.create({
			doc: content,
			extensions,
		}),
		parent: div,
	});
};
