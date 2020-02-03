{ pkgs, config, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    ansible
    awscli
    git
    minikube
    unstable.kubernetes-helm
    unstable.google-cloud-sdk
    unstable.kops
    unstable.kubectl
    unstable.terraform
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
  };

}
