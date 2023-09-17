{
  pkgs,
  config,
  ...
}: {
  services.swayidle = {
    enable = true;

    events = [
      {
        event = "lock";
        command = "${config.programs.swaylock.package}/bin/swaylock --daemonize";
      }
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
    ];

    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.chayang}/bin/chayang && ${pkgs.systemd}/bin/loginctl lock-session && ${config.wayland.windowManager.sway.package}/bin/swaymsg output \\\\* power off";
        resumeCommand = "${config.wayland.windowManager.sway.package}/bin/swaymsg output \\\\* power on";
      }
    ];
  };
}
