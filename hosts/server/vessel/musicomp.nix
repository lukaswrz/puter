{
  self,
  lib,
  pkgs,
  ...
}: {
  services.musicomp.jobs.main = {
    music = "/srv/music";
    comp = "/srv/compmusic";
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    inhibitsSleep = true;
    post = let
      remoteDir = self.nixosConfigurations.abacus.config.services.navidrome.settings.MusicFolder;
      rsyncExe = lib.getExe pkgs.rsync;
      rsh = "${lib.getExe pkgs.openssh} -i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
    in ''
      ${rsyncExe} \
        --archive \
        --recursive \
        --delete \
        --update \
        --mkpath \
        --verbose --verbose \
        --exclude lost+found \
        --rsh ${lib.escapeShellArg rsh} \
        /srv/compmusic/ root@wrz.one:${remoteDir}
    '';
  };
}
