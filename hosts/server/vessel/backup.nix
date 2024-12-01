{
  attrName,
  config,
  lib,
  pkgs,
  ...
}: let
  backups = {
    music = "/srv/music";
    safe = "/srv/safe";
    storage = "/srv/storage";
    sync = config.services.syncthing.dataDir;
  };
in {
  systemd = lib.mkMerge (map (
    backupName: let
      systemdName = "${backupName}-backup";
    in {
      timers.${systemdName} = {
        description = "Local rsync Backup ${backupName}";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "*-*-* 03:00:00";
          Persistent = true;
          Unit = "${systemdName}.service";
        };
      };

      services.${systemdName} = {
        description = "Local rsync Backup ${backupName}";
        serviceConfig = {
          Type = "oneshot";
          User = "root";
          Group = "root";
        };
        script = ''
          ${lib.getExe pkgs.rsync} --verbose --verbose --archive --update --delete --mkpath -- ${backups.${backupName}}/ /srv/backup/${backupName}/
        '';
      };
    }
  ) (lib.attrNames backups));

  age.secrets = lib.mkSecrets {"restic-${attrName}" = {};};

  services.restic.backups.${attrName} = {
    repository = "sftp:u385962@u385962.your-storagebox.de:/restic/${attrName}";
    initialize = true;
    paths = [
      backups.safe
      backups.sync
    ];
    passwordFile = config.age.secrets."restic-${attrName}".path;
    pruneOpts = ["--keep-daily 7" "--keep-weekly 5" "--keep-monthly 12"];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };
    extraOptions = ["sftp.args='-i /etc/ssh/ssh_host_ed25519_key -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'"];
  };
}
