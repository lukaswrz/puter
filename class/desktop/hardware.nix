{pkgs, ...}: {
  hardware = {
    bluetooth.enable = true;
    xone.enable = true;
    xpadneo.enable = true;
    opentabletdriver.enable = true;
    opengl = {
      driSupport32Bit = true;
      extraPackages32 = [
        pkgs.pkgsi686Linux.libvdpau-va-gl
        pkgs.pkgsi686Linux.vaapiVdpau
      ];
    };
  };
}
