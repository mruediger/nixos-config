{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    ansible
    awscli
    git
    minikube
    unstable.kubernetes-helm
    (unstable.google-cloud-sdk.withExtraComponents [ unstable.google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    gnumake
    yq-go
    bind
    pwgen
    complete-alias

    terraform
    terragrunt

    unstable.kops
    unstable.kubectl
    unstable.vault
    unstable.packer
    unstable.terraformer
  ];

  programs.bash.shellAliases = {
    k = "kubectl";
    g = "git";
    gst = "git status";
  };

  programs.bash.interactiveShellInit = ''
    source ${pkgs.complete-alias}/bin/complete_alias
    complete -F _complete_alias k
    complete -F _complete_alias g
  '';
}
