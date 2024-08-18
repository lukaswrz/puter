{pkgs, ...}: {
  programs.fish.enable = true;

  users.defaultUserShell = pkgs.fish;

  nixpkgs.overlays = [
    (final: prev: {
      fish = prev.fish.overrideAttrs (_: {
        postInstall = ''
          rm $out/share/applications/fish.desktop
        '';
      });
    })
  ];
}
