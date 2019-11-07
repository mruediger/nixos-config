{ pkgs, lib, ... }:
{
  imports = [
    ./unstable.nix
    ./bash.nix
    ./networking.nix
    ./docker.nix
  ];

  environment.systemPackages = with pkgs; [
    bc
    file
    iotop
    jq
    mc
    ncdu
    pigz
    psmisc
    psutils
    pv
    screen
    sysfsutils
    unzip
    usbutils
    wget
    sshfs
    perf
  ];



  nixpkgs.config.allowUnfree = true;
  hardware = {
    enableRedistributableFirmware = true;
    ksm.enable = true;
    cpu = {
      intel.updateMicrocode = true;
      amd.updateMicrocode = true;
    };
  };

  time.timeZone = "Europe/Berlin";
  services.timesyncd.enable = true;

  i18n = {
    consoleKeyMap = "neo";
    defaultLocale = "en_US.UTF-8";
  };

  users = {
    extraUsers = {
      bag = {
        home = "/home/bag";
        isNormalUser = true;
        uid = 1000;
        extraGroups = ["wheel" "networkmanager" "input" "video" ];
      };
    };
  };

  security = {
    sudo = {
      enable = true;
    };
  };

  nix.buildCores = lib.mkDefault 0;
  nix.autoOptimiseStore = true;
}
