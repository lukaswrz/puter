{pkgs, ...}: {
  environment.persistence."/persist".directories = ["/etc/mullvad-vpn"];

  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };
}
