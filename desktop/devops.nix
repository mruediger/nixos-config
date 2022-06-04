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
    unstable.terraform_1
    unstable.vault
    unstable.packer
    unstable.terraformer
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
  };

  programs.bash.interactiveShellInit = ''
    source ${pkgs.kubectl}/share/bash-completion/completions/kubectl.bash
    complete -F __start_kubectl k
  '';
}
