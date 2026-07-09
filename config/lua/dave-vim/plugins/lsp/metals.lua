vim.lsp.config("metals", {
  root_markers = { ".bsp/", "build.sbt", "build.sc", { "build.gradle", "build.gradle.kts" }, "pom.xml" }
})
vim.lsp.enable("metals")
