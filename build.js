import { build } from "esbuild";
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
