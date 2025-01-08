{config, ...}: {
  services.resolved.enable = true;

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall.enable = false;
  };

  users.groups.networkmanager.members = config.users.normalUsers;
}
