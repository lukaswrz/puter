{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  package = inputs.hxwrap.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  environment = {
    systemPackages = [ package ];

    sessionVariables =
      let
        exe = builtins.baseNameOf (lib.getExe package);
      in
      {
        EDITOR = exe;
        VISUAL = exe;
      };
  };
}
