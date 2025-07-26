{
  lib,
  phps,
  symlinkJoin,
  symfony-cli,
  makeWrapper,
}: let
  package = symfony-cli;
in
  # Tell Symfony's CLI where it can access the different PHP versions
  symlinkJoin {
    inherit (package) pname version meta;

    paths = [package];

    buildInputs = [makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/${package.meta.mainProgram} \
        --suffix PATH : ${lib.makeBinPath (builtins.attrValues phps)}
    '';
  }
