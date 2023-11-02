{ pkgs, config, ... }: {
  sops.secrets."env_secret_doubleblind".owner = config.services.nginx.user;

  security.acme.certs."science.tanneberger.me" = {
    webroot = null;
    dnsProvider = "inwx";
    credentialsFile = config.sops.secrets."env_secret_doubleblind".path;
    extraDomainNames = [ "*.science.tanneberger.me" ];
  };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;
    recommendedBrotliSettings = true;

    virtualHosts = {
      #"science.tanneberger.me" = {
      #  enableACME = true;
      #};
      #"~^(?<domain>[^.]+)\.science\.tanneberger\.me$" = {
      #enableACME = true;
      #forceSSL = true;
      #  root = "/var/lib/doubleblind/sites/$domain";
      #};
      "*.science.tanneberger.me" = {
        #enableACME = true;
        forceSSL = true;
        root = "/var/lib/doubleblind/sites/$host";
      };
    };
  };
}
