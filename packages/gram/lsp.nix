{ pkgs }:
[
  # C & C++
  pkgs.clang-tools
  # Dart
  pkgs.dart
  # Go
  pkgs.gopls
  # Java
  pkgs.jdt-language-server
  # Kotlin
  pkgs.kotlin-language-server
  # Lua
  pkgs.lua-language-server
  # Nix
  pkgs.nil
  # Python
  pkgs.basedpyright
  # Rust
  pkgs.rust-analyzer
  # Zig
  pkgs.zls
  # TypeScript
  pkgs.typescript-language-server
  # Bash
  pkgs.bash-language-server
  # Fish
  pkgs.fish-lsp

  # HTML & CSS tooling
  pkgs.emmet-ls
  # HTML & CSS & JSON & ESLint
  pkgs.vscode-langservers-extracted

  # Markdown
  pkgs.marksman
  # Typst
  pkgs.tinymist

  # YAML
  pkgs.yaml-language-server
  # TOML
  pkgs.taplo
]
