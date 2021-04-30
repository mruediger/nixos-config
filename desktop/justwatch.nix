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

  services.openvpn.servers = {
    justwatch-gcp = {
      config = '' config /home/bag/src/nixos/nixos-config/openvpn/jw-mathias.ruediger-gcp.ovpn '';
      up = ''
          ${pkgs.systemd}/bin/resolvectl dns $dev 10.132.10.40
          ${pkgs.systemd}/bin/resolvectl domain $dev c.justwatch-compute.internal.
          '';
      down = "${pkgs.systemd}/bin/resolvectl revert $dev";
    };
  };

  networking.extraHosts = ''
    10.132.4.53 vault-2.justwatch.com
  '';
}
