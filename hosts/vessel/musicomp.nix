{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.musicomp.nixosModules.default
  ];

  services.musicomp.jobs.main = {
    music = "/srv/vault/music";
    comp = "/srv/shrink";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    inhibit = [ "sleep" ];
    post =
      let
        abacusConfig = inputs.self.nixosConfigurations.abacus.config;
        remoteDir = abacusConfig.services.navidrome.settings.MusicFolder;
        remoteDomain = abacusConfig.networking.domain;
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
              /srv/shrink/ root@${lib.escapeShellArg remoteDomain}:${lib.escapeShellArg remoteDir}/
          '';
        };
      in
      lib.getExe package;
  };
}
