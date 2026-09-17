{ pkgs, config, ... }:
{
  environment.systemPackages = with pkgs; [
    ansible

    git
    minikube
    kubernetes-helm
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.config-connector
      google-cloud-sdk.components.cloud_sql_proxy
    ])
    google-cloud-sql-proxy
    gnumake
    yq-go
    bind
    pwgen
    complete-alias
    postgresql

    terraform
    terragrunt
    terramate

    opentofu
    tofu-ls

    kubectl
    kustomize
    pluto #detect deprecated apis
    kubent #detect deprecated apis
    k9s

    vault
    packer
    terraformer
    argocd

    conftest
    openssl
    awscli2
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
