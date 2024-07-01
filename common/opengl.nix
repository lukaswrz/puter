{pkgs, ...}: {
  hardware.opengl = {
    enable = true;
    extraPackages = [
      pkgs.libvdpau-va-gl
      pkgs.vaapiVdpau
    ];
  };
}
