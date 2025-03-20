{ ... }:
{
  services.vault = {
    enable = true;

    address = "127.0.0.1:8200";
    tlsCertFile = "/var/lib/vault/vault-cert.pem";
    tlsKeyFile = "/var/lib/vault/vault-key.pem";
    storageBackend = "raft";
    storagePath = "/var/lib/vault/data";
    storageConfig = ''
      node_id = "local-test-vault"
    '';
    extraConfig = ''
      api_addr = "https://127.0.0.1:8200"
      cluster_addr  = "https://127.0.0.1:8201"
      cluster_name  = "local-test-vault"
      disable_mlock = true
      ui = true
    '';
  };

  environment.variables = {
    VAULT_CACERT = "/var/lib/vault/vault-cert.pem";
    VAULT_ADDR = "https://127.0.0.1:8200";
  };
}
