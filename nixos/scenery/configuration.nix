{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };
    kernelParams = [ "quiet" "splash" ];
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  networking = {
    hostName = "scenery";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };
  };

  users.users = {
    lukas = {
      initialPassword = "lukas";
      shell = pkgs.fish;
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK4U9RzV/gVGBfrCOye7BlS11g5BS7SmuZ36n2ZIJyAX lukas@glacier"
      ];
      extraGroups = [ "wheel" ];
    };
  };
}
