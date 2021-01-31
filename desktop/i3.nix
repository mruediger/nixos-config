{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    libinput
    firefox
    termite
  ];

  services.xserver = {
    enable = true;

    exportConfiguration = true;

    serverFlagsSection = ''
      Option "BlankTime"   "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime"     "0"
      '';

    inputClassSections =
      [''
          Identifier "Tex Yoda II"
          MatchProduct "USB-HID Keyboard Mouse"
          MatchDevicePath "/dev/input/event*"
          Option "EmulateWheel" "true"
          Option "EmulateWheelButton" "2"
          Option "Emulate3Buttons" "false"
          Option "XAxisMapping" "6 7"
          Option "YAxisMapping" "4 5"
       ''];

    layout = "de";
    xkbVariant = "neo";

    displayManager = {
      lightdm = {
        enable = true;
        greeters = {
          gtk = {
            enable = true;
          };
        };
      };
    };

    windowManager = {
      i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        extraPackages = with pkgs; [
          dmenu
          i3lock
          i3status
          feh
        ];
      };
    };
  };


  # save windowsize of file selector
  programs.dconf.enable = true;

  systemd.services.i3lock = {
    enable = true;
    before = [ "sleep.target" "suspend.target" ];
    wantedBy = [ "sleep.target" "suspend.target" ];
    serviceConfig = {
      Type = "forking";
      User = "bag";
      Environment = "DISPLAY=:0";
      ExecStart = "${pkgs.i3lock}/bin/i3lock -c 000000";
    };
  };

}
