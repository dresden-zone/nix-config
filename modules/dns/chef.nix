{ pkgs, config, ... }: {

  sops.secrets.postgres_password_chef.owner = config.dresden-zone.chef.user;

  dresden-zone.chef = {
    enable = true;

    host = "127.0.0.1";
    port = 3781;

    database = {
      host = "127.0.0.1";
      port = config.services.postgresql.port;
      passwordFile = config.sops.secrets.postgres_password_chef.path;
      user = "dresden-zone-dns";
      database = "dresden-zone-dns";
    };
  };

  systemd.services."chef" = {
    after = [ "postgresql.service" ];
    wants = [ "postgresql.service" ];
  };

  services = {
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        "chef.${config.dresden-zone.domain}" = {
          forceSSL = true;
          enableACME = true;
          locations = {
            "/" = {
              proxyPass = with config.dresden-zone.chef; "http://${host}:${toString port}/";
              proxyWebsockets = true;
              extraConfig = ''
                more_set_headers "Access-Control-Allow-Credentials: true";
              '';
            };
          };
        };
      };
    };
  };
}
