{
  lib,
  inputs,
  pkgs,
  ...
}: {
  environment = let
    package = inputs.myvim.packages.${pkgs.system}.default;
  in {
    systemPackages = [package];
    variables = let
      name = builtins.baseNameOf (lib.getExe package);
    in {
      EDITOR = name;
      VISUAL = name;
    };
  };
}
