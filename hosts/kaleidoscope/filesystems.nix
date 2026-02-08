{config, pkgs, ...}: {
  environment.systemPackages = [ pkgs.rclone ];

  fileSystems = {
    "/" = {
      fsType = "ext4";
      label = "main";
      options = [
        "noatime"
      ];
    };
    fileSystems."${config.users.users.insomniac.home}/Media" = {
      device = "vessel:/srv/vault/media";
      fsType = "rclone";
      options = [
        "nodev"
        "nofail"
        "allow_other"
        "args2env"
        "ro"
        "config=${pkgs.writeText ''
          [vessel]
          type = sftp
          host = vessel.tailnet.helveticanonstandard.net
          user = root
          key_file = /etc/ssh/ssh_host_ed25519_key
        ''}"
      ];
    };
  };
}
