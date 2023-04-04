{ config, pkgs, ... }:
{
  programs.waybar = {
    enable = true;
    #    style = builtins.readFile ./files/waybar-style.css;
    #
    #    settings = [{
    #      layer = "top";
    #      position = "top";
    #      height = 20;
    #      modules-left = [ "sway/workspaces" "sway/mode" ];
    #      modules-center = [ "sway/window" ];
    #      modules-right = [ "network#wifi" "pulseaudio" "temperature" "cpu" "memory" "clock" "tray" ];
    #
    #      "sway/workspaces" = {
    #        "disable-scroll" = false;
    #        "all-outputs" = false;
    #        "numeric-first" = true;
    #        "format" = "{name}";
    #      };
    #
    #      "sway/mode" = {
    #        "format" = "<span style=\"italic\">{}</span>";
    #      };
    #
    #      "tray" = {
    #        "spacing" = 10;
    #      };
    #
    #      "clock" = {
    #        "format" = "{=%Y-%m-%d  %H=%M}";
    #      };
    #
    #      "temperature" = {
    #        "critical-threshold" = 80;
    #        "format" = "{temperatureC}°C ";
    #      };
    #
    #      "battery" = {
    #        "states" = {
    #          "good" = 95;
    #          "warning" = 30;
    #          "critical" = 5;
    #        };
    #        "format" = "bat= {capacity}%";
    #
    #        "format-icons" = [ "" "" "" "" "" ];
    #      };
    #
    #      "pulseaudio" = {
    #        "format" = "{icon} {volume}%";
    #        "format-icons" = [ "奔" "墳" "" ];
    #        "scroll-step" = 3;
    #      };
    #
    #      "network#wifi" = {
    #        "interface" = "wlp0s20f3";
    #        "format-wifi" = " {essid} {ipaddr}";
    #        "format-ethernet" = "{ipaddr}";
    #        "format-disconnected" = "Disconnected";
    #      };
    #
    #      "network#wg0" = {
    #        "interface" = "wg0";
    #        "format-ethernet" = "{ipaddr}";
    #        "format-disconnected" = "Disconnected";
    #      };
    #    }];
  };
}
