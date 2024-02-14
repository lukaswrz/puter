{
  lib,
  pkgs,
  ...
}: let
  package = pkgs.helix;
in {
  environment = {
    systemPackages = [package];
    variables = {
      EDITOR = lib.getExe package;
      VISUAL = lib.getExe package;
    };
  };
}
