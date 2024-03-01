{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    ansible

    git
    minikube
    unstable.kubernetes-helm
    (unstable.google-cloud-sdk.withExtraComponents [
      unstable.google-cloud-sdk.components.gke-gcloud-auth-plugin
      unstable.google-cloud-sdk.components.config-connector
    ])
    gnumake
    yq-go
    bind
    pwgen
    complete-alias

    terraform
    terragrunt
    terramate

    unstable.kubectl
    unstable.pluto #detect deprecated apis
    unstable.kubent #detect deprecated apis

    unstable.vault
    unstable.packer
    unstable.terraformer
    unstable.argocd


  ];

  programs.bash.shellAliases = {
    k = "kubectl";
    g = "git";
    gst = "git status";

    tf = "terraform";
    tg = "terragrunt";
    tm = "terramate";
  };

  programs.bash.interactiveShellInit = ''
    source ${pkgs.complete-alias}/bin/complete_alias
    complete -F _complete_alias k
    complete -F _complete_alias g

    complete -F _complete_alias tf
    complete -F _complete_alias tg
    complete -F _complete_alias tm
  '';
}
