{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.code;

  languageServers = [
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
    pkgs.basedpyright # TODO: use pkgs.ty when gram supports it
    pkgs.ruff
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
  ];

  debugAdapters = [
    # C & C++
    pkgs.lldb
    # Go
    pkgs.delve
  ];
in
{
  options.profiles.code = {
    enable = lib.mkEnableOption "code";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.gram
    ]
    ++ languageServers
    ++ debugAdapters;
  };
}
