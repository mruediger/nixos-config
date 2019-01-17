{ pkgs, config, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in {
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    git
    aws
    unstable.terraform
    unstable.google-cloud-sdk
    unstable.kubectl
    #    aws-mfa
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
  };

}
