let
  users = {
    "lukas@flamingo" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAztZgcRBHqX8Wb2nAlP1qCKF205M3un/D1YnREcO7Dy";
    "lukas@glacier" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4U9RzV/gVGBfrCOye7BlS11g5BS7SmuZ36n2ZIJyAX";
  };

  hosts = {
    abacus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHoUgClpkOlBEffQOb9KkVn970RwnIhU0OiVr7P2WVzg";
    vessel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKkYcOb1JPNLTJtob1TcuC08cH9P2APAhLR26RYd573d";
  };
in {
  inherit users hosts;

  desktops = {
    inherit (hosts) glacier flamingo;
  };

  servers = {
    inherit (hosts) abacus vessel;
  };
}
