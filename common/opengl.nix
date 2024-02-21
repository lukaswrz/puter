{pkgs, ...}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = [
      pkgs.libvdpau-va-gl
      pkgs.vaapiVdpau
    ];
  };
}
