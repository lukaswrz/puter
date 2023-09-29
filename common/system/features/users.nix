{
  inputs,
  pkgs,
  config,
  ...
}: {
  sops.secrets."users/lukas".neededForUsers = true;

  programs.fish.enable = true;
  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "!";
      lukas = {
        isNormalUser = true;
        shell = pkgs.fish;
        hashedPasswordFile = config.sops.secrets."users/lukas".path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4U9RzV/gVGBfrCOye7BlS11g5BS7SmuZ36n2ZIJyAX lukas@glacier"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAztZgcRBHqX8Wb2nAlP1qCKF205M3un/D1YnREcO7Dy lukas@flamingo"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMC6vIcPgOHiAnG1be8IQVePlrsxN/X9PEFJghS6EcOb lukas@scenery"
        ];
        extraGroups = ["wheel"];
      };
    };
  };

  nix.settings.allowed-users = [config.users.users.lukas.name];
}
