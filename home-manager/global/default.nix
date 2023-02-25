{ inputs, outputs, lib, config, pkgs, ... }: {
  nixpkgs.config = {
    allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = (_: true);
  };

  home.homeDirectory = lib.mkDefault "/home/${config.home.username}";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [ ];

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "22.11";
}
