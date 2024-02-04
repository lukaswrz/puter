let
  users = {
    "lukas@flamingo" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAztZgcRBHqX8Wb2nAlP1qCKF205M3un/D1YnREcO7Dy";
    "lukas@glacier" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4U9RzV/gVGBfrCOye7BlS11g5BS7SmuZ36n2ZIJyAX";
    "lukas@scenery" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMC6vIcPgOHiAnG1be8IQVePlrsxN/X9PEFJghS6EcOb";
  };

  hosts = {
    glacier = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrKpoDV/ImivtTZVbSsQ59IbGYVvSsKls4av2Zc9Nk8";
    abacus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoUgClpkOlBEffQOb9KkVn970RwnIhU0OiVr7P2WVzg";
    scenery = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHDS4LGl73WhC7NSzFe0ghZ0EwLjuP/43GGS65pPpu0";
    vessel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkYcOb1JPNLTJtob1TcuC08cH9P2APAhLR26RYd573d";
    flamingo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIInV+UpCZhoTwgkgnCzCPEu3TD5b5mu6tagRslljrFJ/";
  };
in {
  "user-lukas.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues hosts);
  "mail-lukas.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "nextcloud-lukas.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
}
