{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    nixos-option
  ];

  nix = {
    autoOptimiseStore = true;

    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "weekly";
      persistent = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
}
