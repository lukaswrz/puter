{ pkgs, config, ... }: {
  wayland.windowManager.sway = {
    enable = true;

    systemdIntegration = true;

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_DBUS_REMOTE=1
      export QT_QPA_PLATFORM=wayland-egl
      export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      export _JAVA_AWT_WM_NONREPARENTING=1
      export SDL_VIDEODRIVER=wayland
      export BEMENU_OPTS='--tb #3971ed --tf #1d1f21 --fb #1d1f21 --ff #c5c8c6 --nb #1d1f21 --nf #c5c8c6 --hb #282a2e --hf #ffffff --sb #1d1f21 --sf #c5c8c6 --scb #373b41 --scf #3971ed --scrollbar autohide --fn monospace --bottom'
      export GTK_THEME=Adwaita:dark
      export XDG_SESSION_DESKTOP="''${XDG_SESSION_DESKTOP:-sway}"
    '';

    config = {
      modifier = "Mod4";
      terminal = "${pkgs.alacritty}/bin/alacritty";

      defaultWorkspace = "workspace number 1";

      gaps = {
        smartBorders = "on";
        smartGaps = true;
      };

      window = {
        titlebar = false;

        commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria.app_id = "firefox";
          }
          {
            command = "inhibit_idle fullscreen";
            criteria.app_id = "mpv";
          }
        ];
      };

      workspaceAutoBackAndForth = true;

      input."type:keyboard" = {
        repeat_rate = "45";
        repeat_delay = "300";
      };

      bars = [{
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
        command = "${pkgs.sway}/bin/swaybar";
        position = "top";
        trayOutput = "*";
        fonts = {
          names = [ "NotoSansMono Nerd Font" "monospace" ];
          style = "Regular";
          size = 12.0;
        };
        colors = {
          background = "#0e0e0ef0";
          separator = "#121616f4";
          statusline = "#121616f4";
          focusedWorkspace = {
            border = "#3971ed";
            background = "#3971ed";
            text = "#0e0e0ef0";
          };
          activeWorkspace = {
            border = "#c5c8c6";
            background = "#969896";
            text = "#0e0e0ef0";
          };
          inactiveWorkspace = {
            border = "#121616f4";
            background = "#121616f4";
            text = "#c5c8c6";
          };
          urgentWorkspace = {
            border = "#cc342b";
            background = "#cc342b";
            text = "#0e0e0ef0";
          };
          bindingMode = {
            border = "#fba922";
            background = "#fba922";
            text = "#0e0e0ef0";
          };
        };
      }];

      colors = {
        focused = {
          border = "#c5c8c6";
          background = "#3971ed";
          text = "#0e0e0ef0";
          indicator = "#3971ed";
          childBorder = "#3971ed";
        };
        focusedInactive = {
          border = "#121616f4";
          background = "#121616f4";
          text = "#c5c8c6";
          indicator = "#969896";
          childBorder = "#121616f4";
        };
        unfocused = {
          border = "#121616f4";
          background = "#0e0e0ef0";
          text = "#c5c8c6";
          indicator = "#121616f4";
          childBorder = "#121616f4";
        };
        urgent = {
          border = "#cc342b";
          background = "#cc342b";
          text = "#0e0e0ef0";
          indicator = "#cc342b";
          childBorder = "#cc342b";
        };
        placeholder = {
          border = "#0e0e0ef0";
          background = "#0e0e0ef0";
          text = "#c5c8c6";
          indicator = "#0e0e0ef0";
          childBorder = "#0e0e0ef0";
        };
        background = "#ffffff";
      };

      floating.criteria = [
        { app_id = "neovidefloat"; }
        { app_id = "mpvfloat"; }
        { app_id = "alacrittyfloat"; }
      ];

      menu =
        "${pkgs.bemenu}/bin/bemenu-run --no-exec | xargs ${pkgs.sway}/bin/swaymsg exec --";

      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;

          inherit (config.wayland.windowManager.sway.config)
            left down up right menu terminal;
        in
        {
          "${mod}+Shift+q" = "kill";

          "${mod}+d" = "exec ${menu}";

          "${mod}+Return" = "exec ${terminal}";
          "${mod}+Shift+Return" = "exec ${terminal} --class alacrittyfloat";

          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          "${mod}+Space" = "focus mode_toggle";
          "${mod}+Shift+Space" = "floating toggle";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";
          "${mod}+F1" = "workspace number 11";
          "${mod}+F2" = "workspace number 12";
          "${mod}+F3" = "workspace number 13";
          "${mod}+F4" = "workspace number 14";
          "${mod}+F5" = "workspace number 15";
          "${mod}+F6" = "workspace number 16";
          "${mod}+F7" = "workspace number 17";
          "${mod}+F8" = "workspace number 18";
          "${mod}+F9" = "workspace number 19";
          "${mod}+F10" = "workspace number 20";
          "${mod}+F11" = "workspace number 21";
          "${mod}+F12" = "workspace number 22";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";
          "${mod}+Shift+F1" = "move container to workspace number 11";
          "${mod}+Shift+F2" = "move container to workspace number 12";
          "${mod}+Shift+F3" = "move container to workspace number 13";
          "${mod}+Shift+F4" = "move container to workspace number 14";
          "${mod}+Shift+F5" = "move container to workspace number 15";
          "${mod}+Shift+F6" = "move container to workspace number 16";
          "${mod}+Shift+F7" = "move container to workspace number 17";
          "${mod}+Shift+F8" = "move container to workspace number 18";
          "${mod}+Shift+F9" = "move container to workspace number 19";
          "${mod}+Shift+F10" = "move container to workspace number 20";
          "${mod}+Shift+F11" = "move container to workspace number 21";
          "${mod}+Shift+F12" = "move container to workspace number 22";

          Print = "exec " + pkgs.writeShellScript "grabraw" ''
            f=$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/$(date +'screenshot-%Y%m%d-%H%M%S').png
            ${pkgs.grim}/bin/grim -t png - | tee -- "$f" | ${pkgs.wl-clipboard}/bin/wl-copy
            ${pkgs.libnotify}/bin/notify-send --icon "$f" -- "$f copied to clipboard."
          '';
          "Shift+Print" = "exec " + pkgs.writeShellScript "grabregion" ''
            f=$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/$(date +'screenshot-%Y%m%d-%H%M%S').png
            ${pkgs.slurp}/bin/slurp | ${pkgs.grim}/bin/grim -t png -g - - | tee -- "f" | ${pkgs.wl-clipboard}/bin/wl-copy
            ${pkgs.libnotify}/bin/notify-send --icon "$f" -- "$f copied to clipboard."
          '';
          "Control+Shift+Print" = "exec " + pkgs.writeShellScript "grabcolor" ''
            c=$(${pkgs.slurp}/bin/slurp -b 00000000 -p | ${pkgs.grim}/bin/grim -g - - | ${pkgs.imagemagick}/bin/convert - -format '%[pixel:p{0,0}]' txt:- | tail --lines 1 | cut -d ' ' -f 4)
            ${pkgs.wl-clipboard}/bin/wl-copy --trim-newline <<< "$c"
            ${pkgs.libnotify}/bin/notify-send -- "$c copied to clipboard."
          '';

          "${mod}+x" = "split h";
          "${mod}+y" = "split v";

          "${mod}+f" = "fullscreen toggle";
          "${mod}+a" = "focus parent";
          "${mod}+c" = "focus child";

          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";

          "${mod}+Shift+z" = ''
            exec ${pkgs.sway}/bin/swaynag \
              -t warning \
              -m 'What do you want to do?' \
              -b 'Exit sway' 'systemctl --user stop sway-session.target && ${pkgs.sway}/bin/swaymsg exit' \
              -b 'Shutdown' 'systemctl --user stop sway-session.target && shutdown now' \
              -b 'Reboot' 'systemctl --user stop sway-session.target && reboot' \
              -b 'Suspend' 'loginctl lock-session && systemctl suspend' \
              -b 'Hibernate' 'loginctl lock-session && systemctl hibernate'
          '';

          "${mod}+b" = "exec ${pkgs.mako}/bin/makoctl dismiss";
          "${mod}+Shift+b" = "exec ${pkgs.mako}/bin/makoctl dismiss --all";

          XF86AudioRaiseVolume = "exec ${pkgs.pamixer}/bin/pamixer --increase 1";
          XF86AudioLowerVolume = "exec ${pkgs.pamixer}/bin/pamixer --decrease 1";
          "Shift+XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --increase 10";
          "Shift+XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --decrease 10";
          XF86AudioMute = "exec ${pkgs.pamixer}/bin/pamixer --mute";
          "Shift+XF86AudioMute" = "exec ${pkgs.pamixer}/bin/pamixer --unmute";
          XF86AudioMicMute = "exec ${pkgs.pamixer}/bin/pamixer --default-source --mute";
          "Shift+XF86AudioMicMute" = "exec ${pkgs.pamixer}/bin/pamixer --default-source --unmute";
          "${mod}+n" = "exec ${pkgs.pamixer}/bin/pamixer --mute";
          "${mod}+Shift+n" = "exec ${pkgs.pamixer}/bin/pamixer --unmute";
          "${mod}+m" = "exec ${pkgs.pamixer}/bin/pamixer --default-source --mute";
          "${mod}+Shift+m" = "exec ${pkgs.pamixer}/bin/pamixer --default-source --unmute";

          XF86AudioPause = "exec ${pkgs.mpc-cli}/bin/mpc pause";
          XF86AudioPlay = "exec ${pkgs.mpc-cli}/bin/mpc play";
          XF86AudioPrev = "exec ${pkgs.mpc-cli}/bin/mpc prev";
          XF86AudioNext = "exec ${pkgs.mpc-cli}/bin/mpc next";

          XF86MonBrightnessUp = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +1%";
          XF86MonBrightnessDown = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 1%-";
          "Shift+XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +10%";
          "Shift+XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 10%-";

          "${mod}+Apostrophe" = "move workspace to output right";

          "${mod}+Minus" = "scratchpad show";
          "${mod}+Shift+Minus" = "move scratchpad";
          "${mod}+Underscore" = "move container to scratchpad";

          "${mod}+Shift+s" = "exec loginctl lock-session";

          XF86PowerOff = "exec loginctl lock-session";
          "Shift+XF86PowerOff" = "exec systemctl suspend-then-hibernate";

          XF86Eject = "exec loginctl lock-session";
          "Shift+XF86Eject" = "exec systemctl suspend-then-hibernate";

          Pause = "exec loginctl lock-session";
          "Shift+Pause" = "exec systemctl suspend-then-hibernate";

          "Mod1+Space" = "exec makoctl dismiss";
          "Shift+Mod1+Space" = "exec makoctl dismiss --all";

          "${mod}+r" = "mode resize";
          "${mod}+g" = "mode gaps";
          "${mod}+p" = "mode mpc";
          "${mod}+i" = "mode microphone";
          "${mod}+t" = "mode clipboard";
          "${mod}+v" = "mode volume";
          "${mod}+u" = "mode brightness";
        };

      modes = {
        resize = {
          h = "resize shrink width 1 px or 1 ppt";
          j = "resize grow height 1 px or 1 ppt";
          k = "resize shrink height 1 px or 1 ppt";
          l = "resize grow width 1 px or 1 ppt";
          "Shift+h" = "resize shrink width 10 px or 10 ppt";
          "Shift+j" = "resize grow height 10 px or 10 ppt";
          "Shift+k" = "resize shrink height 10 px or 10 ppt";
          "Shift+l" = "resize grow width 10 px or 10 ppt";

          Return = "mode default";
          Escape = "mode default";
        };

        volume = {
          j = "exec ${pkgs.pamixer}/bin/pamixer --decrease 1";
          k = "exec ${pkgs.pamixer}/bin/pamixer --increase 1";
          "Shift+j" = "exec ${pkgs.pamixer}/bin/pamixer --decrease 10";
          "Shift+k" = "exec ${pkgs.pamixer}/bin/pamixer --increase 10";

          Return = "mode default";
          Escape = "mode default";
        };

        microphone = {
          XF86AudioRaiseVolume = "exec ${pkgs.pamixer}/bin/pamixer --default-source --increase 1";
          XF86AudioLowerVolume = "exec ${pkgs.pamixer}/bin/pamixer --default-source --decrease 1";
          "Shift+XF86AudioRaiseVolume" = "exec ${pkgs.pamixer}/bin/pamixer --default-source --increase 10";
          "Shift+XF86AudioLowerVolume" = "exec ${pkgs.pamixer}/bin/pamixer --default-source --decrease 10";

          Return = "mode default";
          Escape = "mode default";
        };

        brightness = {
          j = "exec ${pkgs.brightnessctl}/bin/brightnessctl set 1%-";
          k = "exec ${pkgs.brightnessctl}/bin/brightnessctl set +1%";

          Return = "mode default";
          Escape = "mode default";
        };

        clipboard = {
          c = "exec ${pkgs.wl-clipboard}/bin/wl-copy --clear";

          Return = "mode default";
          Escape = "mode default";
        };

        "gaps inner" = {
          plus = "gaps inner current plus 1";
          minus = "gaps inner current minus 1";
          "0" = "gaps inner current set 0";

          "Shift+plus" = "gaps inner all plus 1";
          "Shift+minus" = "gaps inner all minus 1";
          "Shift+0" = "gaps inner all set 0";

          Return = "mode default";
          Escape = "mode default";
        };

        "gaps outer" = {
          plus = "gaps outer current plus 1";
          minus = "gaps outer current minus 1";
          "0" = "gaps outer current set 0";

          "Shift+plus" = "gaps outer all plus 1";
          "Shift+minus" = "gaps outer all minus 1";
          "Shift+0" = "gaps outer all set 0";

          Return = "mode default";
          Escape = "mode default";
        };

        gaps = {
          o = ''mode "gaps outer"'';
          i = ''mode "gaps inner"'';

          Return = "mode default";
          Escape = "mode default";
        };

        "mpc volume" = {
          j = "exec ${pkgs.mpc-cli}/bin/mpc volume -1";
          k = "exec ${pkgs.mpc-cli}/bin/mpc volume +1";
          "Shift+j" = "exec exec ${pkgs.mpc-cli}/bin/mpc volume -10";
          "Shift+k" = "exec exec ${pkgs.mpc-cli}/bin/mpc volume +10";

          Return = "mode default";
          Escape = "mode default";
        };

        mpc = {
          XF86AudioRaiseVolume = "exec ${pkgs.mpc-cli}/bin/mpc volume +1";
          XF86AudioLowerVolume = "exec ${pkgs.mpc-cli}/bin/mpc volume -1";
          "Shift+XF86AudioRaiseVolume" = "exec ${pkgs.mpc-cli}/bin/mpc volume +10";
          "Shift+XF86AudioLowerVolume" = "exec ${pkgs.mpc-cli}/bin/mpc volume -10";

          j = "exec ${pkgs.mpc-cli}/bin/mpc next";
          k = "exec ${pkgs.mpc-cli}/bin/mpc prev";

          c = "exec ${pkgs.mpc-cli}/bin/mpc toggle";

          o = "exec ${pkgs.mpc-cli}/bin/mpc consume on";
          "Shift+o" = "exec ${pkgs.mpc-cli}/bin/mpc consume off";

          "1" = "exec ${pkgs.mpc-cli}/bin/mpc single on";
          "Shift+1" = "exec ${pkgs.mpc-cli}/bin/mpc single off";

          r = "exec ${pkgs.mpc-cli}/bin/mpc random on";
          "Shift+r" = "exec ${pkgs.mpc-cli}/bin/mpc random off";

          p = "exec ${pkgs.mpc-cli}/bin/mpc stop";

          s = "exec ${pkgs.mpc-cli}/bin/mpc shuffle";

          h = "exec ${pkgs.mpc-cli}/bin/mpc seek -00:00:01";
          l = "exec ${pkgs.mpc-cli}/bin/mpc seek +00:00:01";
          "Shift+h" = "exec ${pkgs.mpc-cli}/bin/mpc seek -00:00:10";
          "Shift+l" = "exec ${pkgs.mpc-cli}/bin/mpc seek +00:00:10";

          v = ''mode "mpc volume"'';

          Return = "mode default";
          Escape = "mode default";
        };
      };
    };

    extraConfig = ''
      seat seat0 xcursor_theme "Adwaita"
      seat seat0 hide_cursor 10000
    '';
  };
}
