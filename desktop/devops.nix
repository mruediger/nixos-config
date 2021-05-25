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
    yq-go
    bind
    pwgen
    unstable.kops
    unstable.kubectl
    unstable.terraform_0_14
    unstable.vault
    unstable.packer
    unstable.terraformer
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
  };

}
