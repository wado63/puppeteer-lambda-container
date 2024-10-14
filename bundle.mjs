import * as esbuild from 'esbuild'
import { globSync } from 'glob'

const entryPoints = globSync('./src/**/*.ts')

await esbuild.build({
  entryPoints: entryPoints,
  bundle: true,
  platform: 'node',
  format: 'esm',
  outdir: './dist',
  banner: {
    // commonjs用ライブラリをESMプロジェクトでbundleする際に生じることのある問題への対策
    js: 'import { createRequire } from "module"; import url from "url"; const require = createRequire(import.meta.url); const __filename = url.fileURLToPath(import.meta.url); const __dirname = url.fileURLToPath(new URL(".", import.meta.url));',
  },
})
