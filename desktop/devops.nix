{ pkgs, config, ... }:
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
    complete-alias
    unstable.kops
    unstable.kubectl
    unstable.terraform_1
    unstable.vault
    unstable.packer
    unstable.terraformer
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
    g = "git";
  };

  programs.bash.interactiveShellInit = ''
    source ${pkgs.complete-alias}/bin/complete_alias
    complete -F _complete_alias k
    complete -F _complete_alias g
  '';
}
