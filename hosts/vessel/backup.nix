{
  attrName,
  config,
  lib,
  pkgs,
  ...
}: let
  safePath = "/srv/storage/safe";
in {
  systemd = {
    timers.local-backup = {
      description = "Local rsync Backup";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*-*-* 03:00:00";
        Persistent = true;
        Unit = "local-backup.service";
      };
    };

    services.local-backup = {
      description = "Local rsync Backup";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.rsync} --verbose --verbose --archive --update --delete /srv/storage/ /srv/backup/";
        User = "root";
        Group = "root";
      };
    };

    tmpfiles.settings = {
      "10-storage-safe".${safePath}.d = {
        user = "root";
        group = "root";
        mode = "0755";
      };
    };
  };

  fileSystems."/srv/backup" = {
    device = "/dev/disk/by-label/backup";
    fsType = "btrfs";
    options = ["subvol=/" "compress=zstd" "noatime"];
  };

  age.secrets."restic-${attrName}".file = ../../secrets/restic-${attrName}.age;

  services.restic.backups.${attrName} = {
    repository = "sftp:u385962@u385962.your-storagebox.de:/restic/${attrName}";
    initialize = true;
    paths = [safePath];
    passwordFile = config.age.secrets."restic-${attrName}".path;
    pruneOpts = ["--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12"];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };
    extraOptions = ["sftp.args='-i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"];
  };
}
