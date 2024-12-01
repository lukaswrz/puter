{pkgs, ...}: {
  services.printing = {
    enable = true;
    webInterface = true;
    cups-pdf.enable = true;
    drivers = [
      pkgs.gutenprint
      pkgs.gutenprintBin
      pkgs.hplip
      pkgs.hplipWithPlugin
      pkgs.postscript-lexmark
      pkgs.samsung-unified-linux-driver
      pkgs.splix
      pkgs.brlaser
      pkgs.brgenml1lpr
      pkgs.cnijfilter2
    ];
  };
}
