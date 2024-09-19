{ pkgs, inputs, ... }:
{
  disabledModules = [
    "services/misc/ollama.nix"
  ];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/misc/ollama.nix"
  ];

  services.ollama = {
    enable = true;
    package = pkgs.unstable.ollama;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.3";
  };
}
