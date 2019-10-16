{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    awscli
    kubernetes-helm
    ansible
    unstable.terraform
    unstable.google-cloud-sdk
    unstable.kubectl
    unstable.minikube
    unstable.kops
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
  };

}
