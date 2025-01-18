{config, ...}: {
  services.resolved.enable = true;

  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };

  users.groups.networkmanager.members = config.users.normalUsers;
}
