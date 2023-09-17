{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./features/bottom.nix
    ./features/direnv.nix
    ./features/fish.nix
    ./features/git.nix
    ./features/helix.nix
    ./features/readline.nix
  ];

  home.packages = with pkgs; [
    curl
    file
    ncdu
    netcat-openbsd
    procs
    progress
    pv
    rsync
  ];
}
