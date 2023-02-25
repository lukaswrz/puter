{ pkgs, ... }: {
  programs.firefox = {
    enable = true;
    # package = pkgs.wrapFirefox { enableTridactylNative = true; };
  };
}
