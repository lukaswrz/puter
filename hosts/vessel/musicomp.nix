{
  inputs,
  lib,
  pkgs,
  ...
}:
{
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
        remotePath = abacusConfig.services.navidrome.settings.MusicFolder;
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
              /srv/shrink/ root@abacus.tailnet.moontide.ink:${lib.escapeShellArg remotePath}/
          '';
        };
      in
      lib.getExe package;
  };
}
