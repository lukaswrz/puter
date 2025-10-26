{ inputs, pkgs, ... }:
{
  imports = [
    "${inputs.nixpkgs-unstable-small}/nixos/modules/services/misc/rsync.nix"
  ];

  services.rsync = {
    enable = true;
    package = pkgs.rsync;
    jobs = {
      vault = {
        sources = [ "/srv/vault/" ];
        destination = "/srv/sync";
        inhibits = [ "sleep" ];
        settings = {
          archive = true;
          delete = true;
          mkpath = true;
          exclude = "lost+found/";
        };
      };

      roms = {
        sources = [ "/srv/vault/roms/" ];
        destination = "insomniac@kaleidoscope:~/Roms";
        inhibits = [ "sleep" ];
        settings = {
          archive = true;
          delete = true;
          mkpath = true;
        };
      };

      movies = {
        sources = [ "/srv/vault/movies/" ];
        destination = "insomniac@kaleidoscope:~/Videos/Movies";
        inhibits = [ "sleep" ];
        settings = {
          archive = true;
          delete = true;
          mkpath = true;
        };
      };
    };
  };
}
