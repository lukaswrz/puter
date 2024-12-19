{
  pre-commit.hooks = {
    # Nix
    alejandra.enable = true;
    deadnix.enable = true;
    statix.enable = true;

    # Flakes
    flake-checker.enable = true;

    # Shell
    shellcheck.enable = true;
  };
}
