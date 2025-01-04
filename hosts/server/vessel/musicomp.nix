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
    in ''
      ${rsyncExe} \
        --archive \
        --recursive \
        --delete \
        --update \
        --mkpath \
        --verbose --verbose \
        --exclude lost+found \
        --rsh 'ssh -i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' \
        /srv/compmusic/ root@wrz.one:${remoteDir}
    '';
  };

  systemd.services.audiocomp = {
    description = "Compress and sync music";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
      ExecStart = lib.getExe audiocomp;
    };
  };

  systemd.timers.audiocomp = {
    description = "Compress and sync music daily";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
      Unit = "audiocomp.service";
    };
  };
}
