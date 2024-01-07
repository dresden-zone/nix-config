{ lib, config, ... }:
let
  cfg = config.dd-zone.acme;
in
{
  options = {
    dd-zone.acme = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          domainName = lib.mkOption {
            type = lib.types.str;
            description = "Common name of the domain.";
          };
          extraDomainNames = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            description = "Extra domain names.";
          };
        };
      });
      default = [ ];
      description = "List of domains for which certificates should be issued.";
    };
  };

  config = lib.mkIf (lib.length cfg != 0) {
    sops.secrets."acme/cf-dd-zone".owner = "root";

    security.acme = {
      acceptTerms = true;
      defaults.email = "certs@dresden.zone";

      certs = lib.foldl' (x: y: x // y) { } (map
        (cert: {
          "${cert.domainName}" = {
            dnsProvider = "cloudflare";
            credentialsFile = config.sops.secrets."acme/cf-dd-zone".path;
            extraDomainNames = cert.extraDomainNames;
          };
        })
        cfg);
    };
  };
}
