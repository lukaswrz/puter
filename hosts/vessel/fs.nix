{
  fileSystems."/srv/backup" = {
    label = "backup";
    fsType = "ext4";
    options = ["noatime"];
  };
}
