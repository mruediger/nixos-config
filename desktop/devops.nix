{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    ansible
    awscli
    git
    kubernetes-helm
    minikube
    unstable.google-cloud-sdk
    unstable.kops
    unstable.kubectl
    unstable.terraform
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
  };

}
