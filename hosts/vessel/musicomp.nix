{
  inputs,
  self,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.musicomp.nixosModules.default
  ];

  services.musicomp.jobs.main = {
    music = "/srv/music";
    comp = "/srv/compmusic";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    inhibitsSleep = true;
    post =
      let
        remoteDir = self.nixosConfigurations.abacus.config.services.navidrome.settings.MusicFolder;
        package = pkgs.writeShellApplication {
          name = "sync";
          runtimeInputs = [
            pkgs.openssh
            pkgs.rsync
          ];
          text = ''
            rsync \
              --archive \
              --recursive \
              --delete \
              --update \
              --mkpath \
              --verbose --verbose \
              --rsh 'ssh -i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' \
              /srv/void/compmusic/ root@wrz.one:${lib.escapeShellArg remoteDir}
          '';
        };
      in
      lib.getExe package;
  };
}
