{ pkgs, ... }: {
  programs.mpv = {
    enable = true;

    config = {
      vo = "gpu";
      profile = "gpu-hq";
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      video-sync = "display-resample";
      interpolation = true;
      tscale = "oversample";
      force-window = "immediate";
      save-position-on-quit = true;
      screenshot-template = "%f_%wH%wM%wS.%wT";
    };

    scripts = [ pkgs.mpvScripts.mpris ];
  };
}
