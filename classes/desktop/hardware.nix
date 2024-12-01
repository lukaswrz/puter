{pkgs, ...}: {
  hardware = {
    bluetooth.enable = true;
    steam-hardware.enable = true;
    xone.enable = true;
    xpadneo.enable = true;
    # TODO
    # opentabletdriver.enable = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [
        pkgs.libvdpau-va-gl
        pkgs.vaapiVdpau
      ];
      extraPackages32 = [
        pkgs.pkgsi686Linux.libvdpau-va-gl
        pkgs.pkgsi686Linux.vaapiVdpau
      ];
    };
  };
}
