{
  pkgs,
  config,
  lib,
  ...
}: let
  hiraeth = let
    version = "1.1.1";
  in
    pkgs.callPackage pkgs.buildGoModule {
      pname = "hiraeth";
      inherit version;
      src = pkgs.fetchFromGitHub {
        owner = "lukaswrz";
        repo = "hiraeth";
        rev = "v${version}";
        hash = "sha256-GPDGwrYVy9utp5u4iyf0PqIAlI/izcwAsj4yFStYmTE=";
      };
      vendorSha256 = "sha256-bp9xDB7tplHEBR1Z+Ouks2ZwcktAhaZ/zSSPcu7LWr8=";
    };
in {
  services.nginx.virtualHosts."share.defenestrated.systems" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      recommendedProxySettings = true;
      proxyPass = "http://127.0.0.1:8010";
    };
  };

  users = {
    users = {
      hiraeth = {
        isSystemUser = true;
        group = config.users.groups.hiraeth.name;
      };
    };
    groups.hiraeth = {};
  };

  systemd.services.hiraeth = {
    description = "Hiraeth File Sharing Service";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = rec {
      Type = "simple";
      User = config.users.users.hiraeth.name;
      Group = config.users.groups.hiraeth.name;
      # DynamicUser = true;
      StateDirectory = "hiraeth";
      StateDirectoryMode = "0700";
      UMask = "0077";
      WorkingDirectory = "/var/lib/hiraeth";
      ExecStart = "${pkgs.getExe' hiraeth "hiraeth"} run";
      Restart = "on-failure";
      TimeoutSec = 15;
      ReadOnlyPaths = "/etc/hiraeth/hiraeth.toml";

      DevicePolicy = "closed";
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      ProtectHome = "read-only";
      PrivateTmp = true;
      PrivateUsers = true;
      ProtectControlGroups = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = ["AF_INET" "AF_INET6"];
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
    };
  };

  sops.secrets."hiraeth/session_secret" = {
    mode = "0400";
    owner = config.users.users.hiraeth.name;
    group = config.users.users.hiraeth.group;
  };

  environment.etc."hiraeth/hiraeth.toml" = let
    settings = {
      address = "localhost:8010";
      name = "hiraeth";
      data = "data";
      database_file = "hiraeth.db";
      trusted_proxies = [
        "127.0.0.1"
      ];
      inline_types = [
        "image/png"
        "image/jpeg"
        "application/pdf"
      ];
      session_secret_file = config.sops.secrets."hiraeth/session_secret".path;
      chunk_size = 8388608;
    };

    settingsFormat = pkgs.formats.toml {};

    settingsFile = settingsFormat.generate "hiraeth.toml" settings;
  in {
    source = settingsFile;

    mode = "0440";
    user = config.users.users.hiraeth.name;
    group = config.users.users.hiraeth.group;
  };
}
