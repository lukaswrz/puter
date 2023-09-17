{pkgs, ...}: {
  services.fnott = {
    enable = true;
    settings = {
      main = {
        min-width = 400;
        max-icon-size = 96;

        stacking-order = "bottom-up";
        anchor = "top-right";
        notification-margin = 5;

        selection-helper = "${pkgs.bemenu}/bin/bemenu";

        background = "263238ff";

        border-color = "546e7acf";
        border-size = 2;

        padding-vertical = 20;
        padding-horizontal = 20;

        title-font = "sans-serif";
        title-color = "ffffffff";
        title-format = "<i>%a%A</i>";

        summary-font = "sans-serif";
        summary-color = "ffffffff";
        summary-format = "<b>%s</b>\n";

        body-font = "sans-serif";
        body-color = "ffffffff";
        body-format = "%b";

        progress-bar-height = 20;
        progress-bar-color = "ffffffff";

        max-timeout = 0;
        default-timeout = 10;
        idle-timeout = 0;
      };

      # TODO
      low = {
        background = "2632388f";
        title-color = "888888ff";
        summary-color = "888888ff";
        body-color = "888888ff";
      };

      normal = {
        background = "263238ff";
        title-color = "ffffffff";
        summary-color = "ffffffff";
        body-color = "ffffffff";
      };

      critical = {
        background = "546e7aaf";
        title-color = "888888ff";
        summary-color = "888888ff";
        body-color = "888888ff";
      };
    };
  };
}
