{ pkgs, ... }: {
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
  };

  services.open-webui = {
    enable = true;
    port = 2345;
  };
}
