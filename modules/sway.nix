{ pkgs, emacs-version, ... }:
let
  theme = import ../themes/gruvbox-dark.nix;
in
{
  services.dbus.enable = true;
  services.pipewire.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };

  environment.systemPackages = with pkgs; [
    dconf
    zathura
    slurp
    grim
    evince

    nemo-with-extensions
    imv
    mpv
    wev

    nyxt
  ];

  home-manager.sharedModules = [
    ({ config, ... }: {
      home.pointerCursor = {
        name = "Paper";
        package = pkgs.paper-icon-theme;
        gtk.enable = true;
      };

      gtk = {
        enable = true;
        theme = {
          name = "Paper";
          package = pkgs.paper-gtk-theme;
        };

        iconTheme = {
          name = "Paper";
          package = pkgs.paper-icon-theme;
        };

        cursorTheme = {
          name = "Paper";
          package = pkgs.paper-icon-theme;
        };
      };

      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          target = "sway-session.target";
        };
        settings.mainBar = {
          modules-left = [ "sway/workspaces" "sway/window" "sway/mode" ];
          modules-right = [ "pulseaudio" "backlight" "network" "battery" "clock" "sway/language" "tray" ];
          backlight = {
            format = "{percent}% {icon}";
            format-icons = [ "" "" "" "" "" "" "" "" "" ];
            on-scroll-down = "light -U 1";
            on-scroll-up = "light -A 1";
          };
          battery = {
            format = "{capacity}% {icon}";
            format-alt = "{time} {icon}";
            format-charging = "{capacity}% 󰢝";
            format-icons = [ "" "" "" "" "" ];
            format-plugged = "{capacity}% ";
            states = {
              critical = 15;
              warning = 30;
            };
          };
          clock = {
            format = "{:%b %d(%H:%M) 󰃰}";
            tooltip-format = ''
      <big>{:%Y %B}</big>
      <tt><small>{calendar}</small></tt>'';
          };
          network = {
            format = "{ifname}";
            format-disconnected = "Disconnected 󱛅";
            format-ethernet = "{ipaddr}/{cidr} 󰈀";
            format-wifi = "Connected ";
            max-length = 50;
            tooltip-format = "{ifname} via {gwaddr} 󰛳";
            tooltip-format-disconnected = "Disconnected";
            tooltip-format-ethernet = "{ifname} ";
            tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          };
          pulseaudio = {
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "󰝟 {icon} {format_source}";
            format-icons = {
              car = "";
              default = [ "" "" "" ];
              hands-free = "󱠰";
              headphone = "";
              headset = "󰋎";
              phone = "";
              portable = "";
            };
            format-muted = "{volume}% {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            on-click = "pavucontrol";
          };
          "sway/workspaces" = { disable-scroll = true; };
          "sway/language" = {
            format = "{short} {variant}";
          };
        };
        style = ''
          * {
            border: none;
            border-radius: 0;
            font-family: RobotoMono Nerd Font;
            font-size: 14px;
            font-weight: 500;
          }

          window#waybar {
            background-color: ${theme.background};
            color: ${theme.foreground};
            /* border-bottom: solid 0px ${theme.background}; */
            border-bottom: solid 2px ${theme.normal.gray};
          }

          #workspaces button {
            color: ${theme.foreground};
          }

          #workspaces button.focused {
            background-color: ${theme.foreground};
            color: ${theme.background};
            border-bottom: none;
          }

          #workspaces button.urgent {
            background-color: ${theme.normal.red};
          }

          widget > * {
            margin-top: 6px;
            margin-bottom: 6px;
          }

          .modules-left > widget > * {
            margin-left: 12px;
            margin-right: 12px;
          }

          .modules-left > widget:first-child > * {
            margin-left: 6px;
          }

          .modules-left > widget:last-child > * {
            margin-right: 18px;
          }

          .modules-right > widget > * {
            padding: 0 12px;
            margin-left: 0;
            margin-right: 0;
            color: ${theme.background};
            background-color: ${theme.foreground};
          }

          .modules-right > widget:last-child > * {
            margin-right: 6px;
          }

          #mode {
            background: transparent;
            color: #fb4934;
          }

          @keyframes blink {
            to {
              color: ${theme.foreground};
            }
          }

          #battery.critical:not(.charging) {
            animation-name: blink;
            animation-duration: 1s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
          }

          label:focus {
            background-color: ${theme.background} ;
          }

          tooltip {
            border-radius: 5px;
            background: #504945;
          }

          tooltip label {
            color: ${theme.foreground};
          }
        '';
      };

      services.mako = {
        enable = true;
        sort = "-time";
        layer = "top";
        anchor = "top-right";
      };

      programs.foot = {
        enable = true;
        settings = {
          main = {
            font = "FiraCode Nerd Font:size=11";
            dpi-aware = "no";
            term =  "xterm-256color";
          };
          colors = {
            background = "282828";
            foreground = "ebdbb2";
            regular0 = "282828";
            regular1 = "cc241d";
            regular2 = "98971a";
            regular3 = "d79921";
            regular4 = "458588";
            regular5 = "b16286";
            regular6 = "689d6a";
            regular7 = "a89984";
            bright0 = "928374";
            bright1 = "fb4934";
            bright2 = "b8bb26";
            bright3 = "fabd2f";
            bright4 = "83a598";
            bright5 = "d3869b";
            bright6 = "8ec07c";
            bright7 = "ebdbb2";
          };
        };
      };

      programs.fuzzel = {
        enable = true;
        settings = {
          main = {
            terminal = "${pkgs.foot}/bin/foot";
            dpi-aware = "no";
            layer = "overlay";
          };
          colors = {
            background = "ebdbb2ff";
            text = "282828ff";
          };
        };
      };

      systemd.user.services.waybar.Service.Environment = "PATH=/run/current-system/sw/bin";

      programs.swaylock = {
        enable = true;
        settings = {
          color = "000000";
          font-size = 24;
          indicator-idle-visible = false;
          indicator-radius = 100;
          line-color = "ffffff";
          show-failed-attempts = true;
        };
      };

      wayland.windowManager.sway = {
        enable = true;
        systemd.enable = true;
        wrapperFeatures = {
          base = true;
          gtk = true;
        };

        config =
          let
            mod = "Mod4";
            alt = "Mod1";
            left = "u";
            right = "a";
            up = "v";
            down = "i";

            mode_layout = "splith (h) splitv (v) parent (p)";
          in
          {
            terminal = "${pkgs.foot}/bin/foot";
            fonts = {
              names = [ "FiraCode Nerd Font" ];
              size = 10.0;
            };

            output = {
              DP-2 = {
                bg = "${../wallpapers/retro_gruvbox_linux_wallpaper.svg} fill";
              };
              DP-1 = {
                pos = "0 0";
              };
              eDP-1 = {
                pos = "0 1080";
              };
            };

            bars = [ ];

            input = {
              "type:keyboard" = {
                xkb_layout = "de(neo),de";
                xkb_options = "grp:alts_toggle";
              };
            };

            modes = {
              ${mode_layout} = {
                "h" = "splith, mode default";
                "v" = "splitv, mode default";
                "p" = "focus parent, mode default";
                "Return" = "mode default";
                "Escape" = "mode default";
                "BackSpace" = "mode default";
                "${mod}+h" = "mode default";
              };
            };

            floating = {
              modifier = "${mod}";
              criteria = [
                {
                  app_id = "pavucontrol";
                }
                {
                  app_id = "^com.nextcloud.desktopclient.nextcloud$";
                }
                {
                  class = "^Steam$";
                  title = "^(?!Steam$)";
                }
              ];
            };

            #menu = "${pkgs.wofi}/bin/wofi --show drun";
            menu = "${pkgs.fuzzel}/bin/fuzzel";
            window.titlebar = false;
            colors =
              {
              focused = {
                background = theme.foreground;
                border = theme.foreground;
                text = theme.background;
                indicator = theme.foreground;
                childBorder = theme.foreground;
              };
              focusedInactive = {
                background = theme.background;
                border = theme.background;
                text = theme.foreground;
                indicator = theme.background;
                childBorder = theme.background;
              };
              unfocused = {
                background = theme.background;
                border = theme.background;
                text = theme.foreground;
                indicator = theme.background;
                childBorder = theme.background;
              };
              urgent = {
                background = theme.normal.red;
                border = theme.normal.red;
                text = theme.foreground;
                indicator = theme.normal.red;
                childBorder = theme.normal.red;
              };
            };

            keybindings =
              let
                cfg = config.wayland.windowManager.sway;
              in
              {
                "${mod}+Return" = "exec ${cfg.config.terminal}";
                "${mod}+d" = "exec ${cfg.config.menu}";

                "${alt}+F4" = "kill";
                "${mod}+l" = "exec ${pkgs.swaylock}/bin/swaylock";

                "${mod}+t" = "layout toggle tabbed split";
                "${mod}+Shift+t" = "layout toggle split";
                "${mod}+f" = "fullscreen";

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

                "${mod}+Control+${left}" = "move workspace to output left";
                "${mod}+Control+${down}" = "move workspace to output down";
                "${mod}+Control+${up}" = "move workspace to output up";
                "${mod}+Control+${right}" = "move workspace to output right";

                "${mod}+Control+Left" = "move workspace to output left";
                "${mod}+Control+Down" = "move workspace to output down";
                "${mod}+Control+Up" = "move workspace to output up";
                "${mod}+Control+Right" = "move workspace to output right";

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
                "${mod}+z" = "workspace Zoom";
                "${mod}+g" = "workspace Games";

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
                "${mod}+Shift+z" = "move container to workspace Zoom";
                "${mod}+Shift+g" = "move container to workspace Games";

                "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 1%-";
                "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_SINK@ 1%+";
                "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
                "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
                "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 1-";
                "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 1+";

                "XF86NotificationCenter" = "input type:touchpad events toggle enabled disabled";

                "${mod}+h" = "mode \"${mode_layout}\"";

                "${mod}+Alt+s" = "exec slurp | grim -g - ${config.xdg.userDirs.pictures}/$(date +'%Y-%m-%d-%H%M%S_grim.png')";

                "${mod}+e" = "exec ${emacs-version}/bin/emacsclient --create-frame";
              };
          };
      };
    })
  ];

}
