{
  services.mpd = {
    enable = true;
    musicDirectory = "/path/to/music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "pipewire"
      }
    '';

    network.startWhenNeeded = true;
  };
}
