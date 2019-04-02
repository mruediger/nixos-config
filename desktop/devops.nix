{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    awscli
    kubernetes-helm
    unstable.terraform
    unstable.google-cloud-sdk
    unstable.kubectl
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
  };

}
