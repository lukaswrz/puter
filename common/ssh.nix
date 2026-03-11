let
  hostKeyPath = "/etc/ssh/ssh_host_ed25519_key";
in
{
  age.identityPaths = [ hostKeyPath ];

  services.openssh = {
    enable = true;
    openFirewall = true;
    hostKeys = [
      {
        path = hostKeyPath;
        type = "ed25519";
      }
    ];
    settings = {
      PermitRootLogin = "without-password";
      PasswordAuthentication = false;
    };
  };
}
