{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./cursor.nix
  ];

  # TODO: darkman

  wayland.windowManager.sway = let
    wpctl = "${pkgs.wireplumber}/bin/wpctl";
    xdg-user-dir = "${pkgs.xdg-user-dirs}/bin/xdg-user-dir";
    notify-send = "${pkgs.libnotify}/bin/notify-send";
    slurp = "${pkgs.slurp}/bin/slurp";
    grim = "${pkgs.grim}/bin/grim";
    wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
    swaynag = "${config.wayland.windowManager.sway.package}/bin/swaynag";
    swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";
    brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    mpc = "${pkgs.mpc-cli}/bin/mpc";
    fnottctl = "${config.services.fnott.package}/bin/fnottctl";
    modifier = "Mod4";
    terminal = "${config.programs.foot.package}/bin/foot";
  in {
    enable = true;

    systemd = {
      enable = true;
      xdgAutostart = true;
    };

    wrapperFeatures = {
      base = true;
      gtk = true;
    };

    # TODO: Remove GTK_THEME
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
      export SUDO_ASKPASS=${
        pkgs.writeShellScript "askpass" ''
          echo -n | ${pkgs.bemenu}/bin/bemenu --password --prompt askpass
        ''
      }
      export GDK_SCALE=1
    '';

    config = {
      inherit modifier terminal;

      startup = [
        {command = "${pkgs.dex}/bin/dex --autostart";}
      ];

      # FIXME: Currently done by extraConfig
      # defaultWorkspace = "workspace number 1";

      gaps = {
        smartBorders = "on";
        smartGaps = true;
      };

      window = {
        titlebar = false;

        commands = [
          {
            command = "inhibit_idle fullscreen";
            criteria.app_id = "mpv";
          }
        ];
      };

      workspaceAutoBackAndForth = true;

      input = {
        "type:keyboard" = {
          xkb_layout = lib.mkDefault "us";
          repeat_rate = "45";
          repeat_delay = "250";
        };

        "type:pointer" = {
          accel_profile = "flat";
        };

        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
        };
      };

      bars = [
        {
          statusCommand = "${config.programs.i3status-rust.package}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
          command = "${config.wayland.windowManager.sway.package}/bin/swaybar";
          position = "top";
          trayOutput = "*";
          fonts = {
            names = ["Iosevka Nerd Font" "monospace"];
            style = "Regular";
            size = 13.0;
          };
          colors = {
            background = "#000000";
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
              border = "#000000";
              background = "#000000";
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
        }
      ];

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
        {app_id = "neovidefloat";}
        {app_id = "mpvfloat";}
        {app_id = "footfloat";}
      ];

      keybindings = {
        "${modifier}+Shift+q" = "kill";

        "${modifier}+d" = "exec ${config.programs.fuzzel.package}/bin/fuzzel";
        "${modifier}+Shift+d" = "exec ${pkgs.bemenu}/bin/bemenu-run --no-exec | xargs ${swaymsg} exec --";

        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+Return" = "exec ${terminal} --class footfloat";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+Space" = "focus mode_toggle";
        "${modifier}+Shift+Space" = "floating toggle";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";
        "${modifier}+F1" = "workspace number 11";
        "${modifier}+F2" = "workspace number 12";
        "${modifier}+F3" = "workspace number 13";
        "${modifier}+F4" = "workspace number 14";
        "${modifier}+F5" = "workspace number 15";
        "${modifier}+F6" = "workspace number 16";
        "${modifier}+F7" = "workspace number 17";
        "${modifier}+F8" = "workspace number 18";
        "${modifier}+F9" = "workspace number 19";
        "${modifier}+F10" = "workspace number 20";
        "${modifier}+F11" = "workspace number 21";
        "${modifier}+F12" = "workspace number 22";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";
        "${modifier}+Shift+F1" = "move container to workspace number 11";
        "${modifier}+Shift+F2" = "move container to workspace number 12";
        "${modifier}+Shift+F3" = "move container to workspace number 13";
        "${modifier}+Shift+F4" = "move container to workspace number 14";
        "${modifier}+Shift+F5" = "move container to workspace number 15";
        "${modifier}+Shift+F6" = "move container to workspace number 16";
        "${modifier}+Shift+F7" = "move container to workspace number 17";
        "${modifier}+Shift+F8" = "move container to workspace number 18";
        "${modifier}+Shift+F9" = "move container to workspace number 19";
        "${modifier}+Shift+F10" = "move container to workspace number 20";
        "${modifier}+Shift+F11" = "move container to workspace number 21";
        "${modifier}+Shift+F12" = "move container to workspace number 22";

        Print =
          "exec "
          + pkgs.writeShellScript "grabraw" ''
            set -e
            set -o pipefail
            f=$(${xdg-user-dir} PICTURES)/$(date +'screenshot-%Y%m%d-%H%M%S').png
            ${grim} -t png - | tee -- "$f" | ${wl-copy} --type image/png
            ${notify-send} --icon "$f" -- "$f copied to clipboard."
          '';
        "Shift+Print" =
          "exec "
          + pkgs.writeShellScript "grabregion" ''
            set -e
            set -o pipefail
            f=$(${xdg-user-dir} PICTURES)/$(date +'screenshot-%Y%m%d-%H%M%S').png
            ${slurp} | ${grim} -t png -g - - | tee -- "$f" | ${wl-copy} --type image/png
            ${notify-send} --icon "$f" -- "$f copied to clipboard."
          '';
        "Control+Shift+Print" =
          "exec "
          + pkgs.writeShellScript "grabcolor" ''
            set -e
            set -o pipefail
            c=$(${slurp} -b 00000000 -p | ${grim} -g - - | ${pkgs.imagemagick}/bin/convert - -format '%[pixel:p{0,0}]' txt:- | tail --lines 1 | cut -d ' ' -f 4)
            ${wl-copy} --type text/plain --trim-newline <<< "$c"
            ${notify-send} -- "$c copied to clipboard."
          '';

        "${modifier}+x" = "split h";
        "${modifier}+y" = "split v";

        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+a" = "focus parent";
        "${modifier}+c" = "focus child";

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";

        "${modifier}+Shift+z" = ''
          exec ${swaynag} \
            -t warning \
            -m 'What do you want to do?' \
            -b 'Exit sway' 'systemctl --user stop sway-session.target && ${swaymsg} exit' \
            -b 'Shutdown' 'systemctl --user stop sway-session.target && shutdown now' \
            -b 'Reboot' 'systemctl --user stop sway-session.target && reboot' \
            -b 'Suspend' 'loginctl lock-session && systemctl suspend' \
            -b 'Hibernate' 'loginctl lock-session && systemctl hibernate'
        '';

        "${modifier}+b" = "exec ${fnottctl} dismiss";
        "${modifier}+Shift+b" = "exec ${fnottctl} actions";

        XF86AudioRaiseVolume = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%+";
        XF86AudioLowerVolume = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%-";
        "Shift+XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 10%+";
        "Shift+XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 10%-";
        XF86AudioMute = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 1";
        "Shift+XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0";
        XF86AudioMicMute = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 1";
        "Shift+XF86AudioMicMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 0";
        "${modifier}+n" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 1";
        "${modifier}+Shift+n" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ 0";
        "${modifier}+m" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 1";
        "${modifier}+Shift+m" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ 0";

        XF86AudioPause = "exec ${mpc} pause";
        XF86AudioPlay = "exec ${mpc} play";
        XF86AudioPrev = "exec ${mpc} prev";
        XF86AudioNext = "exec ${mpc} next";

        XF86MonBrightnessUp = "exec ${brightnessctl} set +1%";
        XF86MonBrightnessDown = "exec ${brightnessctl} set 1%-";
        "Shift+XF86MonBrightnessUp" = "exec ${brightnessctl} set +10%";
        "Shift+XF86MonBrightnessDown" = "exec ${brightnessctl} set 10%-";

        "${modifier}+Apostrophe" = "move workspace to output right";

        "${modifier}+Minus" = "scratchpad show";
        "${modifier}+Shift+Minus" = "move scratchpad";
        "${modifier}+Underscore" = "move container to scratchpad";

        "${modifier}+Shift+s" = "exec loginctl lock-session";

        XF86PowerOff = "exec loginctl lock-session";
        "Shift+XF86PowerOff" = "exec systemctl suspend-then-hibernate";

        XF86Eject = "exec loginctl lock-session";
        "Shift+XF86Eject" = "exec systemctl suspend-then-hibernate";

        Pause = "exec loginctl lock-session";
        "Shift+Pause" = "exec systemctl suspend-then-hibernate";

        "${modifier}+r" = "mode resize";
        "${modifier}+g" = "mode gaps";
        "${modifier}+p" = "mode mpc";
        "${modifier}+i" = "mode microphone";
        "${modifier}+t" = "mode clipboard";
        "${modifier}+v" = "mode volume";
        "${modifier}+u" = "mode brightness";
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
          k = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%+";
          j = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 1%-";
          "Shift+k" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 10%+";
          "Shift+j" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 10%-";

          Return = "mode default";
          Escape = "mode default";
        };

        microphone = {
          XF86AudioRaiseVolume = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SOURCE@ 1%+";
          XF86AudioLowerVolume = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SOURCE@ 1%-";
          "Shift+XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SOURCE@ 10%+";
          "Shift+XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SOURCE@ 10%-";

          Return = "mode default";
          Escape = "mode default";
        };

        brightness = {
          j = "exec ${brightnessctl} set 1%-";
          k = "exec ${brightnessctl} set +1%";

          Return = "mode default";
          Escape = "mode default";
        };

        clipboard = {
          c = "exec ${wl-copy} --clear";

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
          j = "exec ${mpc} volume -1";
          k = "exec ${mpc} volume +1";
          "Shift+j" = "exec exec ${mpc} volume -10";
          "Shift+k" = "exec exec ${mpc} volume +10";

          Return = "mode default";
          Escape = "mode default";
        };

        mpc = {
          XF86AudioRaiseVolume = "exec ${mpc} volume +1";
          XF86AudioLowerVolume = "exec ${mpc} volume -1";
          "Shift+XF86AudioRaiseVolume" = "exec ${mpc} volume +10";
          "Shift+XF86AudioLowerVolume" = "exec ${mpc} volume -10";

          j = "exec ${mpc} next";
          k = "exec ${mpc} prev";

          c = "exec ${mpc} toggle";

          o = "exec ${mpc} consume on";
          "Shift+o" = "exec ${mpc} consume off";

          "1" = "exec ${mpc} single on";
          "Shift+1" = "exec ${mpc} single off";

          r = "exec ${mpc} random on";
          "Shift+r" = "exec ${mpc} random off";

          p = "exec ${mpc} stop";

          s = "exec ${mpc} shuffle";

          h = "exec ${mpc} seek -00:00:01";
          l = "exec ${mpc} seek +00:00:01";
          "Shift+h" = "exec ${mpc} seek -00:00:10";
          "Shift+l" = "exec ${mpc} seek +00:00:10";

          v = ''mode "mpc volume"'';

          Return = "mode default";
          Escape = "mode default";
        };

        # TODO: bind
        # wall = {
        #   s = pkgs.writeShellScript "setwall" ''
        #     set -euo pipefail
        #     shopt -s nullglob
        #     shopt -s globstar

        #     # select the output first...

        #     file=$(
        #       for file in *
        #       do
        #         echo "''${file@Q}"
        #       done | ${pkgs.bemenu}/bin/bemenu --lines 10 --prompt askpass
        #     )

        #     if [[ $? != 0 ]]; then
        #       exit 1
        #     fi
        #   '';
        # };
      };

      seat."*".xcursor_theme = "${config.home.pointerCursor.name} ${builtins.toString config.home.pointerCursor.size}";
    };

    # FIXME: Should be done by defaultWorkspace
    extraConfig = ''
      workspace number 1
    '';
  };
}
