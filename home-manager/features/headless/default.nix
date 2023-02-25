{ pkgs, ... }: {
  imports =
    [ ./fish.nix ./git.nix ./helix.nix ./readline.nix ./ssh.nix ./zellij.nix ./bottom.nix ];

  home.packages = with pkgs; [ ncdu curl ];
}
