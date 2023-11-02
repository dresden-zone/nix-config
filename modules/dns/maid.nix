{ pkgs, config, ... }: {

  sops.secrets.postgres_password_maid.owner = config.dresden-zone.maid.user;

  dresden-zone.maid = {
    enable = true;

    host = "127.0.0.1";
    port = 3782;

    database = {
      host = "127.0.0.1";
      port = config.services.postgresql.port;
      passwordFile = config.sops.secrets.postgres_password_maid.path;
      user = "dresden-zone-dns";
      database = "dresden-zone-dns";
    };
  };

  systemd.services."maid" = {
    after = [ "postgresql.service" ]; # maybe add chef here
    wants = [ "postgresql.service" ];
  };
}
