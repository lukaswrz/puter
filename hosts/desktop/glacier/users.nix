{config, ...}: {
  users.users.guest = {
    description = "Guest";
    uid = 1001;
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets."user-guest".path;
    openssh.authorizedKeys.keys = builtins.attrValues config.pubkeys.users;
  };
}
