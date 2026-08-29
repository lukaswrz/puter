{
  services.fwupd.enable = true;

  hardware = {
    bluetooth.enable = true;
    steam-hardware.enable = true;
    xone.enable = true;
    xpadneo.enable = true;
    gcadapter.enable = true;
    nitrokey.enable = true;
    enableAllFirmware = true;
  };

  boot.kernel.sysctl = {
    # This is required due to some games being unable to reuse their TCP ports
    # if they're killed and restarted quickly - the default timeout is too
    # large.
    "net.ipv4.tcp_fin_timeout" = 5;
    # Use MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
    # See comment in include/linux/mm.h in the kernel tree.
    "vm.max_map_count" = 2147483642;
  };
}
