{ pkgs, config, lib, ... }:
let
  slack = pkgs.slack.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      rm $out/bin/slack

      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    '';
  });
in
{
  home.packages = with pkgs; [
    unstable.google-chrome
    pulseaudio # for pactl
    slack
    dconf
    zathura
  ];

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
  };

  programs.mako = {
    enable = true;
    sort = "-time";
    layer = "top";
    anchor = "top-right";
  };

  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  systemd.user.services.waybar.Service.Environment = "PATH=/run/current-system/sw/bin";

  programs.swaylock = {
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
    systemdIntegration = true;
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
        terminal = "${pkgs.alacritty}/bin/alacritty";
        fonts = {
          names = [ "FiraCode Nerd Font" ];
          size = 10.0;
        };

        bars = [ ];

        input = {
          "type:keyboard" = {
            xkb_layout = "de(neo),de";
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

        menu = "${pkgs.rofi-wayland}/bin/rofi -show drun";

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

            "${mod}+1" = "workspace number 1";
            "${mod}+2" = "workspace number 2";
            "${mod}+3" = "workspace number 3";
            "${mod}+4" = "workspace number 4";
            "${mod}+5" = "workspace number 5";
            "${mod}+6" = "workspace number 6";
            "${mod}+7" = "workspace number 7";
            "${mod}+8" = "workspace number 8";
            "${mod}+9" = "workspace number 9";
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
            "${mod}+Shift+z" = "move container to workspace Zoom";
            "${mod}+Shift+g" = "move container to workspace Games";

            "XF86AudioLowerVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ -5%";
            "XF86AudioRaiseVolume" = "exec pactl set-sink-volume @DEFAULT_SINK@ +5%";
            "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";
            "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
            "XF86MonBrightnessDown" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 1-";
            "XF86MonBrightnessUp" = "exec ${pkgs.brightnessctl}/bin/brightnessctl s 1+";

            "${mod}+h" = "mode \"${mode_layout}\"";
          };
      };
  };
}
