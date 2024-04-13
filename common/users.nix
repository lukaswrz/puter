{config, ...}: {
  age.secrets.user-lukas.file = ../secrets/user-lukas.age;

  users = {
    mutableUsers = false;

    groups.lukas = {};

    users = {
      root.hashedPassword = "!";
      lukas = {
        isNormalUser = true;
        hashedPasswordFile = config.age.secrets.user-lukas.path;
        openssh.authorizedKeys.keys = builtins.attrValues (import ../pubkeys.nix).users;
        extraGroups = ["wheel" "networkmanager" "gamemode"];
        linger = true;
      };
    };
  };

  services.displayManager.sddm.settings.Autologin.User = "lukas";
}
