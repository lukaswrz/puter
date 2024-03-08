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
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4U9RzV/gVGBfrCOye7BlS11g5BS7SmuZ36n2ZIJyAX lukas@glacier"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAztZgcRBHqX8Wb2nAlP1qCKF205M3un/D1YnREcO7Dy lukas@flamingo"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMC6vIcPgOHiAnG1be8IQVePlrsxN/X9PEFJghS6EcOb lukas@scenery"
        ];
        extraGroups = ["wheel" "networkmanager" "gamemode"];
        linger = true;
      };
    };
  };
}
