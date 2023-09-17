{
  pkgs,
  config,
  ...
}: {
  services.flatpak.enable = true;

  # Workaround for https://github.com/NixOS/nixpkgs/issues/119433
  system.fsPackages = [pkgs.bindfs];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = ["ro" "resolve-symlinks" "x-gvfs-hide"];
    };
    # TODO
    # aggregatedIcons = pkgs.buildEnv {
    #   name = "system-icons";
    #   paths = config.environment.systemPackages;
    #   pathsToLink = [ "/share/icons" ];
    # };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = ["/share/fonts"];
    };
  in {
    # "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    "/usr/share/icons" = mkRoSymBind "/run/current-system/sw/share/icons";
    "/usr/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
  };
}
