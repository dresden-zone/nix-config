{ lib, pkgs, config, inputs, self, ... }: {

  #sops.secrets.postgres_password_maid = {
  #  owner = "postgres";
  #};
  #sops.secrets.postgres_password_chef = {
  #  owner = "postgres";
  #};

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
    ensureDatabases = [ "dresden_zone_dns" ];
    ensureUsers = [
      {
        name = "maid";
      }
      {
        name = "chef";
        ensurePermissions = {
          "DATABASE dresden_zone_dns" = "ALL PRIVILEGES";
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
      # fixup permissions
      #$PSQL -c "GRANT ALL ON DATABASE dresden_zone_dns TO chef;"
      #$PSQL -d dresden_zone_dns -c "GRANT ALL ON ALL TABLES IN SCHEMA public TO chef;"
      #$PSQL -d dresden_zone_dns -c "GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO chef;"

      # Get maid to SELECT from tables  
      #$PSQL -c "GRANT CONNECT ON DATABASE dresden_zone_dns TO maid;"
      #$PSQL -d dresden_zone_dns -c "GRANT SELECT ON zone, record, record_a, record_aaaa, record_cname, record_ns, record_mx, record_txt TO maid;"
    '';
  };
}
