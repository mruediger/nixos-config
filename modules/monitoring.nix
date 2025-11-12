{ pkgs, config, ... }:
{
  environment.systemPackages = [ pkgs.lm_sensors ];
  services.prometheus = {
    enable = true;
    scrapeConfigs = [
      {
        scrape_interval = "15s";
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
    };
  };

  services.grafana = {
    enable = true;
    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "prometheus";
          type = "prometheus";
          url = "http://localhost:9090";
          editable = true;
        }
      ];
    };
  };
}
