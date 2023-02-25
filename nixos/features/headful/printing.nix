{ pkgs, ... }: {
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    hplip
    postscript-lexmark
    splix
    brlaser
    brgenml1lpr
    brgenml1cupswrapper
  ];
}
