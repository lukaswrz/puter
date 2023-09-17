{pkgs, ...}: {
  systemd.user.services.darkman = {
    Unit = {
      Description = "Framework for dark-mode and light-mode transitions";
      Documentation = ["man:darkman(1)"];
    };

    Service = {
      Type = "dbus";
      BusName = "nl.whynothugo.darkman";
      ExecStart = "${pkgs.darkman}/bin/darkman run";
      Restart = "on-failure";
      TimeoutStopSec = 15;
      Slice = "background.slice";
      LockPersonality = true;
      RestrictNamespaces = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "@system-service"
        "@timer"
        "mincore"
      ];
      MemoryDenyWriteExecute = true;
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };
}
