{lib, ...}: {
  environment.persistence."/persist".files = [
    "/etc/ssh/ssh_host_ed25519_key"
    "/etc/ssh/ssh_host_ed25519_key.pub"
  ];

  age.identityPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];

  services.openssh = {
    enable = true;
    openFirewall = true;
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs.ssh.startAgent = true;

  environment.etc."ssh/ssh_config".text = lib.mkAfter ''
    Compression yes
    ServerAliveInterval 60
  '';
}
