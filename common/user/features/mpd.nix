{config, ...}: {
  services = {
    mpd = {
      enable = true;
      musicDirectory = config.xdg.userDirs.music;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "pipewire"
        }
      '';

      network.startWhenNeeded = true;
    };

    mpdris2 = {
      enable = true;
      multimediaKeys = true;
      notifications = true;
    };
  };
}
