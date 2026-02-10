import esbuild from "esbuild"
import pursPlugin from "esbuild-plugin-purescript"
import copyStaticFiles from "esbuild-copy-static-files"

const isDev = process.env.NODE_ENV === "development";

const ctx = await esbuild
  .context({
    entryPoints: [isDev ? "src/index.js" : "index.js"],
    bundle: true,
    outdir: "dist",
    publicPath: "/",
    plugins: [
      pursPlugin(),
      copyStaticFiles({ src: "./public", dest: "./dist" })
    ],
    logLevel: "info",
    banner: isDev ? {
      js: `(() => {
        new EventSource('/esbuild').addEventListener('change', () => location.reload())
      })();`
    } : {}
  })
  .catch((e) => {
    console.error(e)
    process.exit(1)
  });

if (isDev) {
  await ctx.watch()

  await ctx.serve({
    servedir: "./dist",
    port: 1234,
    fallback: "./dist/index.html"
  })

  console.log("Development server running at http://localhost:1234");
  console.log("Live reload enabled - browser will refresh automatically on file changes");
} else {
  await ctx.rebuild()
  await ctx.dispose()
}
