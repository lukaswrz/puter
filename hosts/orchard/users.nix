{ config, ... }:
{
  users.users.alt = {
    description = "Alt";
    uid = 1001;
    isNormalUser = true;
    hashedPasswordFile = config.age.secrets.user-helvetica.path;
  };
}
