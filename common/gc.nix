{
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than +5";
  };
}
