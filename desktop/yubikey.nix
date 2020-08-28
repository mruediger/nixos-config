{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    opensc
    pcsctools
    gnupg
    libu2f-host
    yubikey-personalization
  ];
  services.pcscd.enable = true;
  services.udev.packages = with pkgs; [
    libu2f-host
    yubikey-personalization
  ];
  hardware.u2f.enable = true;

  environment.shellInit = ''
    export GPG_TTY="$(tty)"
    gpg-connect-agent /bye
    export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
  '';

  # ssh agent and gpg agent + ssh are mutually exclusive
  programs.ssh.startAgent = false;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };
}
