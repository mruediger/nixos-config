# see https://github.com/colemickens/nixpkgs-wayland
{ pkgs, ... }:
{

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swaybg
      swaylock
      swayidle
      xwayland
      dmenu
      termite
      grim
      slurp
      waybar
      mako
      wl-clipboard
    ];
  };

  users.extraUsers.bag.extraGroups = ["sway"];

  environment.systemPackages = with pkgs; [
    fzf
    i3status
    unstable.firefox-wayland
    alacritty
  ];

  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "sway";
      gdm.enable = true;
    };
    libinput.enable = true;
  };

  systemd.services.swaylock = {
    enable = true;
    before = [ "sleep.target" "suspend.target" ];
    wantedBy = [ "sleep.target" "suspend.target" ];
    serviceConfig = {
      Type = "forking";
      User = "bag";
      Environment = "WAYLAND_DISPLAY=wayland-0 XDG_RUNTIME_DIR=/run/user/1000";
      ExecStart = "${pkgs.swaylock}/bin/swaylock"; # -i ${toString ../.}/templates/w95lock.png";
    };
  };
}
