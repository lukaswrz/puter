{ pkgs, ... }: {
  services.swayidle = {
    enable = true;

    events = [
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock --daemonize";
      }
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
    ];

    timeouts = [
      {
        timeout = 595;
        command =
          "${pkgs.libnotify}/bin/notify-send --expire-time 5000 'Ni ni...'";
      }
      {
        timeout = 600;
        command =
          "${pkgs.systemd}/bin/loginctl lock-session && ${pkgs.sway}/bin/swaymsg output '*' dpms off";
        resumeCommand = "${pkgs.sway}/bin/swaymsg output '*' dpms on";
      }
    ];
  };
}
