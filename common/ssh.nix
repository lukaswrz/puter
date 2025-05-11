{
  age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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
      PermitRootLogin = "without-password";
      PasswordAuthentication = false;
    };
  };
}
