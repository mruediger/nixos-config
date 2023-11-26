{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnumake
    complete-alias
    unstable._1password
    unstable.zoom-us
  ];

  environment.variables ={
    VAULT_ADDR = "https://vault-2.justwatch.com:8200";
    GONOSUMDB  = "jus.tw.cx";
  };

  programs.bash.shellAliases = {
    ks="kubectl --context gke_justwatch-compute_europe-west1-b_jw-k8s-stage-eu-1";
    kp="kubectl --context gke_justwatch-compute_europe-west1-d_jw-k8s-prod-eu-1";
    tgs="TF_VAR_env=stage terragrunt";
    tgp="TF_VAR_env=prod terragrunt";
  };

  programs.bash.interactiveShellInit = ''
    source ${pkgs.complete-alias}/bin/complete_alias
    complete -F _complete_alias kp
    complete -F _complete_alias ks
    complete -F _complete_alias tgs
    complete -F _complete_alias tgp
  '';
}
