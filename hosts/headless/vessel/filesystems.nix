{
  fileSystems = {
    "/" = {
      fsType = "ext4";
      label = "main";
      options = ["noatime"];
    };
    "/srv/backup" = {
      label = "backup";
      fsType = "ext4";
      options = ["noatime"];
    };
  };
}
