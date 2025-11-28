import { build } from "esbuild";

await build({
  entryPoints: ["src/codemirror-bundle.js"],
  bundle: true,
  format: "esm",
  target: ["es2020"],
  sourcemap: false,
  loader: { ".wasm": "file" },
  outdir: "static",
  outbase: "src",
  assetNames: "[name]",
  entryNames: "codemirror",
  publicPath: "/",
});
