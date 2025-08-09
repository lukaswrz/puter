{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.rbw
    pkgs.pinentry-curses
  ];
}
