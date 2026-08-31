{
  gram,
  symlinkJoin,
  makeWrapper,
  callPackage,
  lib,
}:
let
  languageServers = callPackage ./lsp.nix { };
  debugAdapters = callPackage ./dap.nix { };
in
symlinkJoin {
  inherit (gram) pname version;

  paths = [ gram ];

  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/gram \
      --suffix PATH : ${lib.makeBinPath (languageServers ++ debugAdapters)}
  '';

  meta = {
    inherit (gram.meta)
      description
      homepage
      changelog
      license
      mainProgram
      maintainers
      ;
  };
}
