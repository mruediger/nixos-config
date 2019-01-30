{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    aws
    kubernetes-helm
    unstable.terraform
    unstable.google-cloud-sdk
    unstable.kubectl
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
  };

}
