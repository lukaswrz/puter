{
  config,
  pkgs,
  ...
}: {
  age.secrets.nextcloud-lukas = {
    file = ../../secrets/nextcloud-lukas.age;
    owner = "nextcloud";
    group = "nextcloud";
  };

  system.fsPackages = [pkgs.sshfs];
  fileSystems."${config.services.nextcloud.home}/data/${config.services.nextcloud.config.adminuser}/files/remote" = {
    device = "u385962@u385962.your-storagebox.de:/";
    fsType = "sshfs";
    options = [
      "allow_other"
      "IdentityFile=/persist/etc/ssh/ssh_host_ed25519_key"
      "_netdev"
      "reconnect"
      "ServerAliveInterval=15"
      "x-systemd.automount"
    ];
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28;

    hostName = "cloud.${config.networking.domain}";
    https = true;

    configureRedis = true;

    # TODO: news
    extraApps = {
      inherit
        (config.services.nextcloud.package.packages.apps)
        bookmarks
        calendar
        contacts
        deck
        forms
        mail
        maps
        notes
        phonetrack
        tasks
        ;
    };
    extraAppsEnable = true;

    database.createLocally = true;
    config = {
      dbtype = "pgsql";

      adminuser = "lukas";
      adminpassFile = config.age.secrets.nextcloud-lukas.path;
    };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    enableACME = true;
    forceSSL = true;
    quic = true;
  };
}
