{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    packer
    vault
    gnumake
  ];

  environment.variables ={
    VAULT_ADDR = "https://vault-2.justwatch.com:8200";
    GONOSUMDB  = "jus.tw.cx";
  };

  programs.bash.shellAliases = {
    ks="kubectl --context gke_justwatch-compute_europe-west1-b_jw-k8s-stage-eu-1";
    kp="kubectl --context gke_justwatch-compute_europe-west1-d_jw-k8s-prod-eu-1";
  };


}
