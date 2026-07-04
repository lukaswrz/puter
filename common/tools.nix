{
  lib,
  pkgs,
  ...
}:
let
  editor = pkgs.helix;
in
{
  environment = {
    systemPackages = [
      editor

      pkgs.usbutils
      pkgs.pciutils
      pkgs.dnsutils
      pkgs.smartmontools

      pkgs.lsof
      pkgs.ncdu
      pkgs.file
      pkgs.nmap
      pkgs.binutils
      pkgs.jq
      pkgs.shpool
      pkgs.progress
      pkgs.magic-wormhole-rs
      pkgs.bottom
      pkgs.rbw
      pkgs.pinentry-curses
      pkgs.sbctl
      pkgs.ouch
      pkgs.cava
    ];

    sessionVariables =
      let
        exe = builtins.baseNameOf (lib.getExe editor);
      in
      {
        EDITOR = exe;
        VISUAL = exe;
      };
  };

  programs = {
    direnv.enable = true;
    nix-index-database.comma.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
    };
    nh = {
      enable = true;
      flake = "git+https://hack.moontide.ink/pingfisher/puter.git";
    };
  };
}
