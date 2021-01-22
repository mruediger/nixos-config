{ pkgs, ... }:
let
{
  environment.systemPackages = with pkgs; [
    packer
    vault
    gnumake
  ];

  environment.etc.vault_yml.text =
    ''
      vault {
        address = "https://vault-2.justwatch.com:8200"
      }
    ''

  programs.bash.shellAliases = {
    kstage="kubectl config use-context gke_justwatch-compute_europe-west1-b_jw-k8s-stage-eu-1";
    kprod="kubectl config use-context gke_justwatch-compute_europe-west1-d_jw-k8s-prod-eu-1";
  };


}
