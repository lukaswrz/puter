{pkgs, ...}: {
  home = {
    username = "lukas";
    packages = with pkgs; [
      nvtop-amd
      mullvad-vpn
    ];
    stateVersion = "23.11";
  };

  wayland.windowManager.sway = let
    primary = "Acer Technologies XB283K KV 120918F984200";
    secondary = "LG Electronics LG HDR 4K 0x00008FEE";
  in {
    config = {
      output.${primary} = {
        mode = "3840x2160@144.004Hz";
        position = "0,0";
        background = ''"$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/sway/primary" fill'';
      };

      output.${secondary} = {
        mode = "3840x2160@59.997Hz";
        position = "3840,-1680";
        transform = "90";
        background = ''"$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/sway/secondary" fill'';
      };

      workspaceOutputAssign = [
        {
          output = primary;
          workspace = "1";
        }
        {
          output = primary;
          workspace = "2";
        }
        {
          output = primary;
          workspace = "3";
        }
        {
          output = primary;
          workspace = "4";
        }
        {
          output = primary;
          workspace = "5";
        }
        {
          output = primary;
          workspace = "6";
        }
        {
          output = primary;
          workspace = "7";
        }
        {
          output = primary;
          workspace = "8";
        }
        {
          output = primary;
          workspace = "9";
        }
        {
          output = primary;
          workspace = "10";
        }
        {
          output = secondary;
          workspace = "11";
        }
        {
          output = secondary;
          workspace = "12";
        }
        {
          output = secondary;
          workspace = "13";
        }
        {
          output = secondary;
          workspace = "14";
        }
      ];

      gaps = {
        inner = 12;
        outer = 14;
      };

      input."Razer Razer DeathAdder V3" = {
        pointer_accel = "0.0";
      };
    };
  };
}
