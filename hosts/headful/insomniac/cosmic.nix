{
  config,
  lib,
  pkgs,
  ...
}: {
  services.greetd.settings.initial_session = {
    user = config.users.mainUser;
    command = ''
      ${lib.getExe' pkgs.coreutils "env"} XCURSOR_THEME="''${XCURSOR_THEME:-Pop}" systemd-cat --identifier start-cosmic ${lib.getExe' pkgs.cosmic-session "start-cosmic"}
    '';
  };

  environment.cosmic.excludePackages = [
    pkgs.cosmic-store
  ];
}
