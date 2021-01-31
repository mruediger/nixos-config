{ pkgs, config, unstable, ... }:
{
  environment.systemPackages = with pkgs; [
    ansible
    awscli
    git
    minikube
    unstable.kubernetes-helm
    google-cloud-sdk
    gnumake
    unstable.kops
    unstable.kubectl
    unstable.terraform
    unstable.vault
    unstable.packer
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
  };

}
