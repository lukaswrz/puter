{
  lib,
  pkgs,
  ...
}:
let
  editor = pkgs.vim-classic;
in
{
  environment = {
    systemPackages = [
      editor

      pkgs.dnsutils
      pkgs.pciutils
      pkgs.smartmontools
      pkgs.usbutils

      pkgs.bottom
      pkgs.curl
      pkgs.fd
      pkgs.ffmpeg
      pkgs.file
      pkgs.forgejo-cli
      pkgs.fzf
      pkgs.jq
      pkgs.lsof
      pkgs.magic-wormhole-rs
      pkgs.ncdu
      pkgs.nmap
      pkgs.pinentry-curses
      pkgs.progress
      pkgs.rbw
      pkgs.ripgrep
      pkgs.sbctl
      pkgs.shpool
      pkgs.wget2
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
    nini = {
      enable = true;
      flake = "git+https://hack.moontide.ink/lukas/puter.git";
    };
  };
}
