import { build } from "esbuild";
import { readFileSync, writeFileSync } from "fs";
import { wasmLoader } from 'esbuild-plugin-wasm'

await build({
  entryPoints: ["src/codemirror.js"],
  bundle: true,
  format: "esm",
  target: ["es2020"],
  sourcemap: false,
  loader: { ".wasm": "file" },
  outdir: "static",
  outbase: "src",
  assetNames: "[name]",
  entryNames: "codemirror",
  plugins: [wasmLoader()],
  publicPath: "/",
  supported: {
    'top-level-await': true,
  },
});

await build({
  entryPoints: ["src/decasify-bundle.js"],
  bundle: true,
  format: "esm",
  target: ["es2020"],
  sourcemap: false,
  outdir: "data",
  outbase: "src",
  entryNames: "decasify",
  plugins: [wasmLoader({ mode: 'embedded' })],
  supported: {
    'top-level-await': true,
  },
});

/* The following monkey business is LLM generated rubbish. I don't know enough about the internals
 * here to do better, but the only utility needed here is some way to trigger our custom sample
 * generator code at some point after the decasify WASM library is loaded and before Paged JS starts
 * doing layout. I'd love to see a contribution from somebody that does this some saner way.
 */
const src = readFileSync("data/decasify.js", "utf8");
const patched = src
  .replace(
    /async function loadWasm[\s\S]*?^}/m,
    ""
  )
  .replace(/var \{ instance, module \} = await loadWasm\(decasify_bg_default, imports\);/, "var { instance } = await WebAssembly.instantiate(decasify_bg_default, imports);")
  .replace(/^export \{.*\};?\n?/m, "");
writeFileSync("data/decasify.js",
  "(async function() {\n" +
  patched +
  "\nwindow.externalLibs._resolveDecasifyReady();\n" +
  "\nvar DecasifyHandler = class extends Paged.Handler {\n" +
  "  constructor(chunker, polisher, caller) { super(chunker, polisher, caller); }\n" +
  "  async beforeParsed(content) {\n" +
  "    await window.externalLibs.decasifyReady;\n" +
  "    window.generateSample(content);\n" +
  "  }\n" +
  "};\n" +
  "Paged.registerHandlers(DecasifyHandler);\n" +
  "})();\n"
);
