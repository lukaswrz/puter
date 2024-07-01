{pkgs, ...}: {
  programs.fish.enable = true;

  users.defaultUserShell = pkgs.fish;

  nixpkgs.overlays = [
    (final: prev: {
      fish = prev.fish.overrideAttrs (oldAttrs: {
        postInstall = ''
          rm $out/share/applications/fish.desktop
        '';
      });
    })
  ];
}
