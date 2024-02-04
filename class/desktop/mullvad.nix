{
  environment.persistence."/persist".directories = ["/etc/mullvad-vpn"];

  services.mullvad-vpn.enable = true;
}
