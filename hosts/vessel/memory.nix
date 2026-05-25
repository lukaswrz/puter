{
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };

  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };
}
