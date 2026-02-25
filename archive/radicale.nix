{
  services.radicale = {
    enable = true;
    settings = {
      server.hosts = [
        "0.0.0.0:5232"
        "[::]:5232"
      ];
      auth = {
        type = "htpasswd";
        # TODO: agenix
        htpasswd_filename = "/etc/radicale/users";
        htpasswd_encryption = "bcrypt";
      };
      storage.filesystem_folder = "/var/lib/radicale/collections";
    };
    rights = {
      root = {
        user = ".+";
        collection = "";
        permissions = "R";
      };
      principal = {
        user = ".+";
        collection = "{user}";
        permissions = "RW";
      };
      calendars = {
        user = ".+";
        collection = "{user}/[^/]+";
        permissions = "rw";
      };
    };
  };
}
