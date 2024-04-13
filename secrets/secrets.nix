let
  users = {
    "lukas@flamingo" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAztZgcRBHqX8Wb2nAlP1qCKF205M3un/D1YnREcO7Dy";
    "lukas@glacier" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4U9RzV/gVGBfrCOye7BlS11g5BS7SmuZ36n2ZIJyAX";
  };

  hosts = {
    glacier = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrKpoDV/ImivtTZVbSsQ59IbGYVvSsKls4av2Zc9Nk8";
    abacus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoUgClpkOlBEffQOb9KkVn970RwnIhU0OiVr7P2WVzg";
    vessel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkYcOb1JPNLTJtob1TcuC08cH9P2APAhLR26RYd573d";
    flamingo = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIInV+UpCZhoTwgkgnCzCPEu3TD5b5mu6tagRslljrFJ/";
  };

  desktops = {
    inherit (hosts) glacier flamingo;
  };

  servers = {
    inherit (hosts) abacus vessel;
  };
in {
  "user-lukas.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues hosts);
  "user-guest.age".publicKeys = (builtins.attrValues users) ++ (builtins.attrValues desktops);
  "mail-lukas.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "vaultwarden.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "nextcloud-lukas.age".publicKeys = (builtins.attrValues users) ++ [hosts.abacus];
  "restic-vessel.age".publicKeys = (builtins.attrValues users) ++ [hosts.vessel];
}
