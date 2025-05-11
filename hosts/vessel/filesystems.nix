{
  fileSystems = {
    "/" = {
      label = "white";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/srv/vault" = {
      label = "black";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/srv/void" = {
      label = "green";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/srv/sync" = {
      label = "red";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };
}
