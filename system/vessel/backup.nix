{
  pkgs,
  lib,
  ...
}: {
  systemd.timers.local-backup = {
    description = "Local rsync Backup";
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "*-*-* 00:00:00";
      Persistent = true;
      Unit = "rsync-backup.service";
    };
  };

  systemd.services.local-backup = {
    description = "Local rsync Backup";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''${lib.getExe pkgs.rsync} --verbose --verbose --archive --update --delete /srv/storage/ /srv/backup/'';
      User = "root";
      Group = "root";
    };
  };

  fileSystems."/srv/backup" = {
    device = "/dev/disk/by-label/backup";
    fsType = "btrfs";
    options = ["subvol=main" "compress=zstd" "noatime"];
  };
}
