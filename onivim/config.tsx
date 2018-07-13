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
  "ui.colorscheme": "gruvbox_dark",
  "experimental.preview.enabled": true,
  "experimental.markdownPreview.enabled": true,

  //"oi.useDefaultConfig": true,
  //"oni.bookmarks": ["~/Documents"],
  //"oni.loadInitVim": false,

  //"editor.fontSize": "12px",
  //"editor.fontFamily": "Monaco",
  "editor.fontSize": "14px",
  "editor.fontFamily": "'Fira Code', Hack, Monaco",

  // UI customizations
  "ui.animations.enabled": true,
  "ui.fontSmoothing": "auto",

  // Language Support - Rust
  "language.rust.languageServer.command": "/Users/agerlach/.cargo/bin/rustup",
  "language.rust.languageServer.arguments": ["run", "stable", "rls"],
  "language.rust.languageServer.rootFiles": ["Cargo.toml"]
};
