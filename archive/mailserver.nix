{
  config,
  pkgs,
  secretsPath,
  ...
}: let
  inherit (config.networking) fqdn;
  
  wellKnownMtaSts = pkgs.writeText "" ''
    version: STSv1
    mode: enforce
    mx: ${fqdn}
    max_age: 86400
  '';
in {
  age.secrets = {
    # mail-lukas.file = secretsPath + /users/mail/lukas.age;
    # mail-helvetica.file = secretsPath + /users/mail/helvetica.age;
    mail-m64.file = secretsPath + /users/mail/m64.age;
  };
  
  # environment.persistence."/persist".directories = [
  #   config.mailserver.dkimKeyDirectory
  #   config.mailserver.mailDirectory
  #   config.mailserver.sieveDirectory
  # ];
  
  mailserver = {
    enable = true;
    openFirewall = true;
    inherit fqdn;
    domains = [
      "moontide.ink"
      # "wrz.one"
      # "helveticanonstandard.net"
    ];
    
    loginAccounts = {
      "m64@moontide.ink" = {
        hashedPasswordFile = config.age.secrets.mail-m64.path;
        aliases = ["postmaster@moontide.ink" "vault@moontide.ink"];
      };
      
      # "lukas@wrz.one" = {
      #   hashedPasswordFile = config.age.secrets.mail-lukas.path;
      #   aliases = ["postmaster@wrz.one"];
      # };
      
      # "helvetica@helveticanonstandard.net" = {
      #   hashedPasswordFile = config.age.secrets.mail-lukas.path;
      #   aliases = ["postmaster@helveticanonstandard.net"];
      # };
    };
    
    certificateScheme = "acme-nginx";
  };
  
  services.nginx.virtualHosts."mta-sts.moontide.ink" = {
    enableACME = true;
    forceSSL = true;
    
    locations = {
      "/".return = "404";
      
      "=/.well-known/mta-sts.txt" = {
        alias = wellKnownMtaSts;
        
        extraConfig = ''
          default_type text/plain;
        '';
      };
    };
  };
}
