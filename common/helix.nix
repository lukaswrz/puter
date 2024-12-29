{
  lib,
  pkgs,
  ...
}: let
  package = pkgs.helix;
in {
  environment.systemPackages = [package];

  environment.sessionVariables = let
    exe = builtins.baseNameOf (lib.getExe package);
  in {
    EDITOR = exe;
    VISUAL = exe;
  };
}
