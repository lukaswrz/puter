{
  lib,
  inputs,
  pkgs,
  ...
}:
let
  spec = {
    entries = [
      {
        displayName = "RetroArch";
        program = "retroarch";
      }
      {
        displayName = "Steam";
        program = "steam";
        args = [
          "-tenfoot"
        ];
      }
    ];
  };

  specFormat = pkgs.formats.json { };

  launcher = pkgs.writeShellApplication {
    name = "launcher";
    runtimeInputs = [
      inputs.xenumenu.packages.${pkgs.system}.default
    ];
    text = ''
      while true; do
        xenumenu --rowcols 3 --exit ${specFormat.generate "spec.json" spec}
      done
    '';
  };
in
{
  services.cage = {
    enable = true;
    program = lib.getExe launcher;
    user = "insomniac";
    environment = {
      WLR_LIBINPUT_NO_DEVICES = "1";
    };
  };
}
