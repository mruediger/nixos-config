{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    terraform
    aws
    google-cloud-sdk
#    aws-mfa
  ];
}
