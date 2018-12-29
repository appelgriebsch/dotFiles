import * as React from "react";
import * as Oni from "oni-api";

export const activate = (oni: Oni.Plugin.Api) => {
  console.log("config activated");

  // Input
  //
  // Add input bindings here:
  //
  oni.input.bind("<c-enter>", () => console.log("Control+Enter was pressed"));

  //
  // Or remove the default bindings here by uncommenting the below line:
  //
  // oni.input.unbind("<c-p>")
};

export const deactivate = (oni: Oni.Plugin.Api) => {
  console.log("config deactivated");
};

export const configuration = {
  //add custom config here, such as

  "ui.colorscheme": "ayu",
  "experimental.preview.enabled": true,
  "experimental.markdownPreview.enabled": true,
  "experimental.vcs.sidebar": true,

  //"oni.useDefaultConfig": true,
  //"oni.bookmarks": ["~/Documents"],
  //"oni.loadInitVim": false,
  //"editor.fontSize": "12px",
  //"editor.fontFamily": "Monaco",
  "editor.fontSize": "14px",
  "editor.fontFamily": "'Fira Code', Hack, Monaco",

  // UI customizations
  "ui.animations.enabled": true,
  "ui.fontSmoothing": "auto",

  "oni.plugins.prettier": {
    formatOnSave: true,
    enabled: true
  },
  "environment.additionalPaths": [
    "/usr/bin",
    "/usr/local/bin",
    "/Users/appelgriebsch/.gvm/pkgsets/go1.11.4/global/bin",
    "/Users/appelgriebsch/.cargo/bin"
  ],
  "language.go.languageServer.arguments": ["-gocodecompletion"],
  "language.rust.languageServer.command": "rustup",
  "language.rust.languageServer.arguments": ["run", "stable", "rls"],
  "language.rust.languageServer.rootFiles": ["Cargo.toml"]
};
