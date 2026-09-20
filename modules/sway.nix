{ pkgs, emacs-version, ... }:
let
  theme = import ../themes/gruvbox-dark.nix;
  stripHash = color: builtins.substring 1 (builtins.stringLength color - 1) color;
in
{
  services.dbus.enable = true;
  services.pipewire.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = { };
  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
    zathura
    slurp
    grim
    evince

    nemo-with-extensions
    imv
    mpv
    wev

    nyxt
    kdePackages.okular
    playerctl
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
        font = {
          name = "Roboto";
          size = 11;
        };
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

        gtk4.theme = config.gtk.theme;
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk";
      };

      programs.waybar = {
        enable = true;
        systemd = {
          enable = true;
          targets = [ "sway-session.target" ];
        };
        settings.mainBar = {
          position = "top";
          height = 25;
          modules-left = [ "sway/workspaces"  "sway/mode" ];
          modules-center = [ "sway/window" ];
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
            format = "{volume}% {icon}  {format_source}";
            format-muted = "{volume}%   {format_source}";
            format-source = "{volume}% 󰍬";
            format-source-muted = "{volume}% 󰍭";
            format-bluetooth = "{volume}%{icon} ";
            format-bluetooth-muted = "󰖁 {icon} ";
            format-icons = {
              car = "";
              default = [ "" "" "" ];
              hands-free = "󱠰";
              headphone = "";
              headset = "󰋎";
              phone = "";
              portable = "";
            };
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
            min-height: 0;
        }

        window#waybar {
            background: ${theme.background};
            border-bottom: 3px solid ${theme.foreground};
            color: ${theme.bright.white};
        }

        #workspaces button {
            padding: 0 5px;
            background: transparent;
            color: ${theme.bright.white};
            border-bottom: 3px solid transparent;
        }

        #workspaces button.focused {
            background: ${theme.bright.orange};
            border-bottom: 3px solid ${theme.bright.orange};
        }

        #mode, #clock, #battery {
            padding: 0 10px;
            margin: 0 5px;
        }

        #mode {
            background: ${theme.normal.red};
            border-bottom: 3px solid ${theme.bright.white};
        }

        #clock {
            background-color: ${theme.bright.orange};
            color: ${theme.bright.white};
        }

        #battery {
            background-color: ${theme.bright.white};
            color: ${theme.background};
        }

        #battery.charging {
            color: ${theme.background};
            background-color: ${theme.normal.green};
        }

        @keyframes blink {
            to {
                background-color: ${theme.bright.white};
                color: ${theme.background};
            }
        }

        #idle_inhibitor, #pulseaudio, #custom-openvpn, #network, #cpu, #memory, #temperature, #backlight, #battery, #clock, #tray {
             padding: 0 6px;
             margin: 0 3px;
        }

        #battery.warning:not(.charging) {
            background: ${theme.normal.red};
            color: ${theme.bright.white};
        }

        #battery.critical:not(.charging) {
            background: ${theme.normal.red};
            color: ${theme.bright.white};
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }
                '';
      };

      services.mako = {
        enable = true;
        settings = {
          sort = "-time";
          layer = "top";
          anchor = "top-right";
        };
      };

      programs.foot = {
        enable = true;
        settings = {
          main = {
            font = "FiraCode Nerd Font:size=11";
            dpi-aware = "no";
            term =  "xterm-256color";
          };
          colors-dark = {
            background = "${stripHash theme.background}";
            foreground = "${stripHash theme.foreground}";
            regular0 = "${stripHash theme.normal.black}";
            regular1 = "${stripHash theme.normal.red}";
            regular2 = "${stripHash theme.normal.green}";
            regular3 = "${stripHash theme.normal.yellow}";
            regular4 = "${stripHash theme.normal.blue}";
            regular5 = "${stripHash theme.normal.purple}";
            regular6 = "${stripHash theme.normal.aqua}";
            regular7 = "${stripHash theme.normal.gray}";
            bright0 = "${stripHash theme.bright.gray}";
            bright1 = "${stripHash theme.bright.red}";
            bright2 = "${stripHash theme.bright.green}";
            bright3 = "${stripHash theme.bright.yellow}";
            bright4 = "${stripHash theme.bright.blue}";
            bright5 = "${stripHash theme.bright.blue}";
            bright6 = "${stripHash theme.bright.aqua}";
            bright7 = "${stripHash theme.bright.gray}"; #originally theme.foreground
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
              names = [ "Roboto Nerd Font" ];
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
                bg = "${../wallpapers/retro_gruvbox_linux_wallpaper.svg} stretch";
              };
            };

            bars = [ ];

            input = {
              "type:keyboard" = {
                xkb_layout = "de,de(neo)";
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
                "Shift+XF86AudioMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
                "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 1%-";
                "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 1%+";

                "XF86AudioNext" = "exec playerctl next";
                "XF86AudioPrev" = "exec playerctl previous";
                "XF86AudioPlay" = "exec playerctl play-pause";
                "XF86AudioStop" = "exec playerctl stop";

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
