{ config, pkgs, ... }:
let
  proxyConfig = { listenPort, proxyUrl ? null, extraLocations ? { }
    , extraConfig ? "", authFile ? null, }: {
      forceSSL = false;
      enableACME = false;
      basicAuthFile = authFile;
      listen = [{
        addr = "0.0.0.0";
        port = listenPort;
      }];
      locations = {
        "/" = {
          proxyPass = proxyUrl;
          extraConfig = extraConfig;
        };
      } // extraLocations;
    };
in {
  config = {

    services.nginx = {
      enable = true;
      # Enable recommended proxy settings.
      recommendedProxySettings = true;
      # Enable recommended TLS settings.
      recommendedTlsSettings = true;
      # Enable recommended optimisation settings.
      recommendedOptimisation = true;
      config = ''
        server {
          listen       10000;
          server_name  localhost;
          location / {
            proxy_pass http://127.0.0.1:5555;
            proxy_set_header Host $host:10000;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

            proxy_http_version    1.1;
            proxy_set_header      Upgrade "websocket";
            proxy_set_header      Connection "Upgrade";
            proxy_read_timeout    86400;
          }
        }
      '';
      # nginx 代理jupyter notebook  
      # virtualHosts."127.0.0.1" =   {
      #   listenPort = 10000;
      #   extraConfig = ''
      #     proxy_pass http://127.0.0.1:5555;
      #     proxy_set_header Host $host:10000;
      #     proxy_set_header X-Real-IP $remote_addr;
      #     proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

      #     proxy_http_version    1.1;
      #     proxy_set_header      Upgrade "websocket";
      #     proxy_set_header      Connection "Upgrade";
      #     proxy_read_timeout    86400;
      #   '';
      # };

      # virtualHosts."192.168.0.110" = {
      #   forceSSL = false;
      #   enableACME = false;
      #   listen = [{
      #     addr = "0.0.0.0";
      #     port = 10001;
      #   }];
      #   locations."/" = {
      #     proxyPass =
      #       "http://127.0.0.1:${toString config.services.grafana.port}";
      #     proxyWebsockets = true;
      #   };
      # };
    };

    networking.firewall.allowedTCPPorts = [ 10000 ];
  };
}
