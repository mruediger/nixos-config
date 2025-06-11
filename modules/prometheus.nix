{ config, ... }:
{

  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
          }
        ];
      }

    ];
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [
          "systemd"
          "logind"
          "wifi"
        ];
      };
      varnish.enable = true;
    };
  };
}
