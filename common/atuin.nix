{
  lib,
  pkgs,
  ...
}: let
  package = pkgs.atuin;
in {
  environment.systemPackages = [package];

  programs.bash.interactiveShellInit = ''
    eval "$(${lib.getExe package} init bash)"
  '';
}
