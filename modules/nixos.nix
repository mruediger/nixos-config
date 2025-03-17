{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.nixos-option
    unstable.nixd
    unstable.nixfmt-rfc-style
  ];

  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    settings.auto-optimise-store = true;

    settings.trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    settings.substituters = [
      "https://nix-community.cachix.org"
    ];

    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
      trusted-users = root bag
    '';

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "weekly";
      persistent = true;
    };
  };
}
