{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    ansible

    git
    minikube
    kubernetes-helm
    (unstable.google-cloud-sdk.withExtraComponents [
      unstable.google-cloud-sdk.components.gke-gcloud-auth-plugin
      unstable.google-cloud-sdk.components.config-connector
      unstable.google-cloud-sdk.components.cloud_sql_proxy
    ])
    unstable.google-cloud-sql-proxy
    gnumake
    yq-go
    bind
    pwgen
    complete-alias
    postgresql

    terraform
    terragrunt
    terramate

    kubectl
    kustomize
    pluto #detect deprecated apis
    kubent #detect deprecated apis

    vault
    packer
    terraformer
    argocd

    conftest
    openssl
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
