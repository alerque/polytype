import { EditorView, lineNumbers } from "@codemirror/view";
import { EditorState } from "@codemirror/state";
import { basicSetup } from "@codemirror/basic-setup";
import { xml } from "@codemirror/lang-xml";
import { html } from "@codemirror/lang-html";
import { css } from "@codemirror/lang-css";
import { javascript } from "@codemirror/lang-javascript";

window.initCodeMirror = function (element, content, language = "text") {
	const languageMap = {
		xml: xml(),
		html: html(),
		css: css(),
		javascript: javascript(),
	};

	let polyTheme = EditorView.baseTheme({
		"&light": {
			backgroundColor: "#fff"
		},
		"&dark": {
			backgroundColor: "#000"
		}
	});

	const extensions = [
		basicSetup,
		lineNumbers(),
		languageMap[language] || [],
		EditorState.readOnly.of(true),
		polyTheme,
	];

	new EditorView({
		state: EditorState.create({
			doc: content,
			extensions,
		}),
		parent: element,
	});
};
