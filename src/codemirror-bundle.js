import { EditorView, lineNumbers } from "@codemirror/view";
import { EditorState } from "@codemirror/state";
import {
	syntaxHighlighting,
	defaultHighlightStyle,
} from "@codemirror/language";
import { css } from "@codemirror/lang-css";
import { html } from "@codemirror/lang-html";
import { javascript } from "@codemirror/lang-javascript";
import { markdown } from "@codemirror/lang-markdown";
import { xml } from "@codemirror/lang-xml";
import { yaml } from "@codemirror/lang-yaml";
import { latex } from "codemirror-lang-latex";

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
	// Aliases to near-matches
	pagedjs: html,
	sile: latex,
	weasyprint: html,
	xelatex: latex,
};

window.initCodeMirror = async function (element, content, language) {
	let polyTheme = EditorView.baseTheme({
		"&light": {
			backgroundColor: "#fff",
		},
		"&dark": {
			backgroundColor: "#000",
		},
	});

	let languageExtension = [];
	const spec = languageMap[language];
	if (spec) {
		const ext = spec();
		languageExtension = ext instanceof Promise ? await ext : ext;
	} else if (language === "typst") {
		console.log("Loading Typst language support");
		try {
			const { typst } = await import("codemirror-lang-typst");
			languageExtension = typst();
		} catch (e) {
			console.warn("Failed to load Typst language support:", e);
		}
	}

	const extensions = [
		EditorState.readOnly.of(true),
		polyTheme,
		lineNumbers(),
		syntaxHighlighting(defaultHighlightStyle),
		languageExtension,
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
