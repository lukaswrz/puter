{
  inputs,
  lib,
  pkgs,
  ...
}: {
  environment = let
    package = inputs.myvim.packages.${pkgs.system}.default;
  in {
    systemPackages = [package];
    variables = lib.genAttrs ["EDITOR" "VISUAL"] (_: lib.getExe package);
  };
}
