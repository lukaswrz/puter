{
  pkgs,
  self,
  ...
}:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5 --keep-since 1w";
      dates = "weekly";
    };
  };

  environment.sessionVariables.NH_FLAKE = "git+https://forgejo@forgejo.helveticanonstandard.net/helvetica/puter.git"; # TODO
}
