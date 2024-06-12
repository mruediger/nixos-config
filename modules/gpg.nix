{ pkgs, ... }:
{
  services.dbus.packages = [ pkgs.gcr ];
  services.gnome.gnome-keyring.enable = true;

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  environment.systemPackages = with pkgs; [
    tpm2-tools
    gnupg
  ];

  users.extraUsers.bag.extraGroups = [ "tss" ];

  home-manager.sharedModules = [
    ({ ... }: {
      programs.password-store = {
        enable = true;
        package = pkgs.pass.override { waylandSupport = true; };
      };

      programs.gpg = {
        enable = true;
        mutableKeys = true;
        mutableTrust = true;
        publicKeys = [
          { source = ../gpg/butterfly.gpg; trust = "ultimate"; }
          { source = ../gpg/farting-unicorn.gpg; trust = "ultimate"; }
          { source = ../gpg/josephine.gpg; trust = "ultimate"; }
          { source = ../gpg/mruediger.gpg; trust = "ultimate"; }
          { source = ../gpg/yubikey.gpg; trust = "ultimate"; }
        ];
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentryPackage = pkgs.pinentry-gnome3;
        enableScDaemon = true;
        grabKeyboardAndMouse = false;
        extraConfig = ''
          allow-emacs-pinentry
          allow-loopback-pinentry
        '';
      };
    })
  ];

}
