{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  boot.tmp.cleanOnBoot = true;
}
