{
  config,
  ...
}:
{
  users.users.helvetica = {
    description = "Insomniac";
    uid = 1000;
    isNormalUser = true;
    password = "";
    openssh.authorizedKeys.keys = builtins.attrValues config.pubkeys.users;
    extraGroups = [ "wheel" ]; # TODO remove
  };
}
