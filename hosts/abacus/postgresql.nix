{
  services.postgresqlBackup = {
    enable = true;
    startAt = "*-*-* 02:00:00";
    location = "/srv/backup/postgresql";
    backupAll = true;
  };
}
