{pkgs, ...}: {
  services.printing.drivers = with pkgs; [
    epson-escpr
    epson-escpr2
  ];
}
