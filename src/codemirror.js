import { EditorView, lineNumbers } from "@codemirror/view";
import { EditorState } from "@codemirror/state";
import { oneDark } from "@codemirror/theme-one-dark";
import {
	syntaxHighlighting,
	defaultHighlightStyle,
	StreamLanguage,
} from "@codemirror/language";
import { lua as luaStreamParser } from "@codemirror/legacy-modes/mode/lua";
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
	css,
	html,
	javascript,
	markdown,
	xml,
	yaml,
	// Unofficial 3rd party languages
	latex,
	typst,
	// Legacy modes (wrapped for the language factory interface)
	lua: () => StreamLanguage.define(luaStreamParser),
	// Aliases to near-matches
	pagedjs: html,
	sile: latex,
	speedata: xml,
	weasyprint: html,
	xelatex: latex,
};

const isDarkMode = window.matchMedia('(prefers-color-scheme: dark)').matches;

export async function initCodeMirror(element, content, language) {
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
		isDarkMode ? oneDark : [],
		lineNumbers(),
		syntaxHighlighting(defaultHighlightStyle),
		languageMap[language] ? languageMap[language]() : [],
	];

	let div = document.createElement("div");
	div.className = element.className;
	element.replaceWith(div);

	const trimmedContent = content.replace(/\n+$/, '');

	new EditorView({
		state: EditorState.create({
			doc: trimmedContent,
			extensions,
		}),
		parent: div,
	});
};
