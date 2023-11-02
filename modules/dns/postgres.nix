{ lib, pkgs, config, inputs, self, ... }: {

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    port = 5432;
    authentication =
      #let
      #  maid-ip = self.nixosConfigurations.notice-me-senpai.config.deployment-TLMS.net.wg.addr4;
      # host	tlms	grafana	${maid-ip}/32	scram-sha-256
      # in
      pkgs.lib.mkOverride 10 ''
        local	all	all	trust
        host	all	all	127.0.0.1/32	trust
        host	all	all	::1/128	trust
      '';
    package = pkgs.postgresql_14;
    ensureDatabases = [ "dresden-zone-dns" ];
    ensureUsers = [
      {
        name = "maid";
      }
      {
        name = "chef";
        ensurePermissions = {
          "DATABASE dresden-zone-dns" = "ALL PRIVILEGES";
          "ALL TABLES IN SCHEMA public" = "ALL";
        };
      }
    ];
  };

  systemd.services.postgresql = {
    unitConfig = {
      TimeoutStartSec = 3000;
    };
    serviceConfig = {
      TimeoutSec = lib.mkForce 3000;
    };
    postStart = lib.mkAfter ''
      # set pw for the users
      $PSQL -c "ALTER ROLE chef WITH PASSWORD '$(cat ${config.sops.secrets.postgres_password_chef.path})';"
      $PSQL -c "ALTER ROLE maid WITH PASSWORD '$(cat ${config.sops.secrets.postgres_password_maid.path})';"

      # fixup permissions
      $PSQL -c "GRANT ALL ON DATABASE dresden-zone-dns TO chef;"
      $PSQL -d dresden-zone-dns -c "GRANT ALL ON ALL TABLES IN SCHEMA public TO chef;"
      $PSQL -d dresden-zone-dns -c "GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO chef;"

      # Get maid to SELECT from tables  
      $PSQL -c "GRANT CONNECT ON DATABASE dresden-zone-dns TO maid;"
      $PSQL -d dresden-zone-dns -c "GRANT SELECT ON zone, record, record_a, record_aaaa, record_cname, record_ns, record_mx, record_txt TO maid;"
    '';
  };
}
