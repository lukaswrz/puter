{
  languages.python.enable = true;

  pre-commit.hooks = {
    # Nix
    alejandra.enable = true;
    deadnix.enable = true;
    statix.enable = true;

    # Flakes
    flake-checker.enable = true;

    # Shell
    shellcheck.enable = true;

    # Python
    pyright.enable = true;
    ruff.enable = true;
    ruff-format.enable = true;
  };
}
