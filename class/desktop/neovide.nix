{pkgs, ...}: let
  package = pkgs.neovide;
in {
  environment.systemPackages = [package];
}
