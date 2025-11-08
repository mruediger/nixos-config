{ ... }:
{
  services.traefik = {
    enable = true;


    staticConfigOptions = {
      api.dashboard = true;
    };

    dynamicConfigOptions = {
      http = {
        routers = {
          prometheus = {
            rule = "Host(`prometheus.localhost`)";
            service = "prometheus";
          };
          grafana = {
            rule = "Host(`grafana.localhost`)";
            service = "grafana";
          };
        };
        services = {
          prometheus = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:9090";
                }
              ];
            };
          };
          grafana = {
            loadBalancer = {
              servers = [
                {
                  url = "http://localhost:3000";
                }
              ];
            };
          };
        };
      };
    };
  };
}
