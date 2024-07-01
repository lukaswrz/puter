{
  inputs,
  lib,
  pkgs,
  ...
}: {
  environment = let
    package = inputs.myvim.packages.${pkgs.system}.default.overrideAttrs (oldAttrs: {
      postInstall = ''
        rm $out/share/applications/nvim.desktop
      '';
    });
  in {
    systemPackages = [package];
    variables = lib.genAttrs ["EDITOR" "VISUAL"] (_: lib.getExe package);
  };
}
