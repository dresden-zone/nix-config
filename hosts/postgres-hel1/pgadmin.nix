{ config, ... }:
{
  sops.secrets."pgadmin/init_admin_pw".owner = config.systemd.services.pgadmin.serviceConfig.User;

  services.pgadmin = {
    enable = true;
    initialEmail = "admin@dresden.zone";
    initialPasswordFile = config.sops.secrets."pgadmin/init_admin_pw".path;
    settings = {
      CONFIG_DATABASE_URI = "postgresql://pgadmin@/pgadmin";
      UPGRADE_CHECK_ENABLED = false;
    };
  };

  services.nginx.virtualHosts."pgadmin.hel1.dresden.zone" = {
    forceSSL = true;
    useACMEHost = "hel1.dresden.zone";
    locations."/".proxyPass = "http://127.0.0.1:${toString config.services.pgadmin.port}";
  };
}
