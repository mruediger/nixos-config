{ pkgs, config, ... }:
{
  nixpkgs.overlays = [
    (self: super:
      {
        terramate = super.terramate.overrideAttrs( old: rec {
          version = "0.11.4";
          src = super.fetchFromGitHub {
            owner = "terramate-io";
            repo = "terramate";
            rev = "v${version}";
            sha256 = "RZBafDaSGW01EdvDg8RUynrSO84/pkh3OcVXlSsZ+ao=";
          };
          vendorHash = "sha256-PwMxmls7sL9RhgvGKKDwxAeObk7HVBtYLOsIYt90dVU=";
        });
      }
    )
  ];

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
