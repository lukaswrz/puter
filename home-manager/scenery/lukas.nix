{pkgs, ...}: {
  home = {
    username = "lukas";
    stateVersion = "23.11";
  };

  wayland.windowManager.sway = {
    config = {
      input."type:keyboard".xkb_layout = "de";

      output.eDP-1 = {
        mode = "1920x1080";
        position = "0,0";
        background = ''"$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/sway/primary" fill'';
      };

      workspaceOutputAssign = [
        {
          output = "e-DP1";
          workspace = "number 1";
        }
        {
          output = "e-DP1";
          workspace = "number 2";
        }
        {
          output = "e-DP1";
          workspace = "number 3";
        }
        {
          output = "e-DP1";
          workspace = "number 4";
        }
        {
          output = "e-DP1";
          workspace = "number 5";
        }
        {
          output = "e-DP1";
          workspace = "number 6";
        }
        {
          output = "e-DP1";
          workspace = "number 7";
        }
        {
          output = "e-DP1";
          workspace = "number 8";
        }
        {
          output = "e-DP1";
          workspace = "number 9";
        }
        {
          output = "e-DP1";
          workspace = "number 10";
        }
      ];

      gaps = {
        inner = 4;
        outer = 6;
      };
    };
  };
}
