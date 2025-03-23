# TODO: unify syncthing.nix files
let
  guiPort = 8384;
in {
  services.syncthing = {
    enable = true;
    systemService = true;
    openDefaultPorts = true;
    guiAddress = let
      host = "0.0.0.0";
      port = builtins.toString guiPort;
    in "${host}:${port}";
  };

  networking.firewall.allowedTCPPorts = [guiPort];
}
