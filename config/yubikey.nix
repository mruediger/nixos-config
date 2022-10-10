{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnupg
    libu2f-host
    opensc
    openssl
    pcsctools
    yubikey-personalization
    yubikey-manager
    (pass.override { waylandSupport = true; })
  ];

  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [
    libu2f-host
    yubikey-personalization
  ];

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  programs.browserpass.enable = true;

  # ssh agent and gpg agent + ssh are mutually exclusive
  programs.ssh.startAgent = false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };
}
