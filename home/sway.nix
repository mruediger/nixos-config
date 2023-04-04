{ pkgs, config, lib, ... }:
{
  home.packages = with pkgs; [
    firefox-wayland
    pulseaudio # for pactl
    slack
    dconf
  ];

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
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
          size = 12.0;
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

        keybindings =
          let
            cfg = config.wayland.windowManager.sway;
          in
          {
            "${mod}+Return" = "exec ${cfg.config.terminal}";
            "${mod}+d" = "exec ${cfg.config.menu}";

            "${alt}+F4" = "kill";
            "${mod}+l" = "exec ${pkgs.swaylock}/bin/swaylock";

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
