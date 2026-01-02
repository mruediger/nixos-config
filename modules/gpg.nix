{ pkgs, ... }:
{
  services.dbus.packages = [ pkgs.gcr ];

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
    tctiEnvironment.enable = true;
  };

  environment.systemPackages = with pkgs; [
    tpm2-tools
    gnupg
    gopass
    gopass-jsonapi
  ];

  programs.browserpass.enable = true;

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
          { source = ../gpg/farting-unicorn.asc; trust = "ultimate"; }
          { source = ../gpg/josephine.asc; trust = "ultimate"; }
          { source = ../gpg/mruediger.asc; trust = "ultimate"; }
          { source = ../gpg/yubikey.asc; trust = "ultimate"; }
        ];
      };

      services.gpg-agent = {
        enable = true;
        enableSshSupport = true;
        pinentry.package = pkgs.pinentry-gnome3;
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
