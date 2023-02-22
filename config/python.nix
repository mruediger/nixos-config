{ pkgs, ... }:
let
  my-python-packages = p: with p; [
    ruamel-yaml
  ];
in
{
  environment.systemPackages = with pkgs; [
    python3.withPackages my-python-packages
  ];
}
