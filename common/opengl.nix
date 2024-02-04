{pkgs, ...}: {
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      pkgs.libvdpau-va-gl
      pkgs.vaapiVdpau
    ];
  };
}
