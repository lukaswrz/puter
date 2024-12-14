{config, ...}: let
  inherit (config.users) mainUser;
in {
  services.resolved.enable = true;

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall.enable = false;
  };

  users.users.${mainUser}.extraGroups = ["networkmanager"];
}
