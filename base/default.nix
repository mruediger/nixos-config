{ pkgs, lib, ... }:
{
  imports = [
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
    nmon
    sysstat
    mtr
    htop
    mprime
    pciutils
    usbutils
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

  console.keyMap = "neo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  users = {
    extraUsers = {
      bag = {
        home = "/home/bag";
        isNormalUser = true;
        uid = 1000;
        extraGroups = ["wheel" "networkmanager" "input" "video" ];
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCopuKlVlLa3RX6m/rmF2iOLZbB99Z43Rxu2gdyKdzPkaGSn3Qh35fC+vvGa90eaZvyHxSuXa20M3CqTdB+VDIb707mCz+H3AubcWns5hOiMqv7u9EPlSGRydRGIh0JIz8h0dEyfvujO+5QaJsuctf5uAeRjh1FK67Yf8RQhHkkO4NBNK2IJvdcsQVmNTCfKAo1c36c2IwS4e9IEjftUea0mt2dpNDraYfZlDDrd1qIFelt+7KmU4UQXwYKWy0gFQ7DvFpa9A9cUyBpRTGJTL7AL4aqGlirWsa/BddVdv0nsCiA9CpI6HtnodIBh3LHpJaqUaAgT/Z8hmibR0JBe/f2A28IMSRvnRuiWu4vqa2Y3jqMyoRJJyM1Sk4KTyRThO4j7zFHAe4px5LYtPY8wPqiOqBZMBLMlq3LSpGOIbKs8MWeCRIz+C5frVtohnhyATJ8PpN7XC5PvP3I2wQBGT+9krMvQphNMug0m+8gXlzQ8Gv1CjpTS2pSV1yaAdpQcgU= bag@josephine"
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0mY0TcE84d7TK5vHt8Fcekm8QBcMN0kA+WT+ED5XF3s87wIQGic/BUteT6At4cL728v7lzdHPTTqYqKLK9Q2vLfz31JhbVWcWwBptSJCjCuAnf7fN9QP+NJ3Bi+/MAlX8wQ7raRhmO2l2u6yL8SE9Ig4BPYwUf60dY97b1t3RXZEUYu1GR0lxpzjCJeER+c9JwczzkegwWa+NmajK2hVOBrbj+BXLiJOTUHVk0r7HU3hkt5YatTQSWAVrP/SY0pcrRidy5Eslyi/cszI6C4DApXAHH+vC6EdBjKL/B3IgujgU0GtVF5ec/Ta3zO09MO0YbKDUDMnRJJV9ruJnyVmCEYCd73E9FklL9Ki1zIPotsyTd/8+5gcoz+p7sNGV1NqtMOH8EEd5OpkDHr1Eyf0qUcZBS5sRb2dbf6p9plv6UuynXMfI+ldYXjB4nLOk3CnNM5RLDFZB4c7HTgp6dGnlBU14tnZ/s7e/Ph3DU/hUkWJ9a44+GEf529vjkMcKocM= bag@butterfly"
        ];
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
