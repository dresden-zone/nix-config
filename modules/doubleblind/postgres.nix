{ lib, pkgs, config, inputs, self, ... }: {

  sops.secrets."postgres_password_doubleblind".owner = config.dresden-zone.doubleblind.user;

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
    ensureDatabases = [ "doubleblind" ];
    ensureUsers = [
      {
        name = "maid";
      }
      {
        name = "doubleblind";
        ensurePermissions = {
          "DATABASE doubleblind" = "ALL PRIVILEGES";
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
      $PSQL -c "ALTER ROLE doubleblind WITH PASSWORD '$(cat ${config.sops.secrets."postgres_password_doubleblind".path})';"
    '';
  };
}
