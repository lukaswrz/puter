{
  helix,
  symlinkJoin,
  makeWrapper,
  pkgs,
}:
let
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
    pkgs.basedpyright
    pkgs.ruff
    # Rust
    pkgs.rust-analyzer
    # Zig
    pkgs.zls
    # TypeScript
    pkgs.nodePackages_latest.typescript-language-server
    # Bash
    pkgs.nodePackages_latest.bash-language-server
    # Nu
    pkgs.nushell

    # HTML & CSS tooling
    pkgs.emmet-ls
    # HTML & CSS & JSON & ESLint
    pkgs.vscode-langservers-extracted

    # Markdown
    pkgs.marksman
    # LaTeX
    pkgs.texlab
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

  clipboardProviders = [
    pkgs.wl-clipboard
  ];
in
symlinkJoin {
  inherit (helix)
    pname
    version
    meta
    passthru
    ;

  paths = [ helix ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/${helix.meta.mainProgram} \
      --suffix PATH : ${pkgs.lib.makeBinPath (languageServers ++ debugAdapters ++ clipboardProviders)}
  '';
}
