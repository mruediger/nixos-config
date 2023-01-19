{ pkgs, config, ... }:
let
  my-python-packages = p: with p; [
    ruamel
  ]

{
  environment.systemPackages = with pkgs; [
    (python3.withPackages my-python-packages)
  ]
}
