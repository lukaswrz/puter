{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  hxwrap = inputs.hxwrap.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  environment = {
    systemPackages = [
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
      hxwrap
    ];

    sessionVariables =
      let
        exe = builtins.baseNameOf (lib.getExe hxwrap);
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
      flake = "git+https://hack.moontide.ink/m64/puter.git";
    };
  };
}
