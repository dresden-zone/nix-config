{ pkgs, config, ... }: {
  sops.secrets."env_secret_doubleblind".owner = config.services.nginx.user;
  sops.secrets."github_client_secret".owner = config.dresden-zone.doubleblind.user;
  sops.secrets."github_hmac_secret".owner = config.dresden-zone.doubleblind.user;
  sops.secrets."github_private_key".owner = config.dresden-zone.doubleblind.user;


  security.acme.certs."science.tanneberger.me" = {
    webroot = null;
    dnsProvider = "inwx";
    credentialsFile = config.sops.secrets."env_secret_doubleblind".path;
    extraDomainNames = [ "science.tanneberger.me" "*.science.tanneberger.me" ];
  };


  #security.acme.certs."doubleblind.science" = {
  #  webroot = null;
  #  dnsProvider = "dreamhost";
  #  credentialsFile = config.sops.secrets."env_secret_doubleblind".path;
  #  extraDomainNames = [ "*.doubleblind.science" ];
  #};

  users.users.nginx.extraGroups = [ "acme" ];

  networking.firewall.allowedTCPPorts = [ 443 80 ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;
    recommendedBrotliSettings = true;

    virtualHosts = {
      "science.tanneberger.me" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          root = "${pkgs.doubleblind-frontend}/bin/browser/";
          index = "index.html";
        };
      };
      "api.science.tanneberger.me" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = with config.dresden-zone.doubleblind.http; "http://${host}:${toString port}";
        };
      };

      #"~^(?<domain>[^.]+)\.science\.tanneberger\.me$" = {
      #enableACME = true;
      #  forceSSL = true;
      #  root = "/var/lib/doubleblind/sites/$domain";
      #};
      "*.science.tanneberger.me" = {
        #enableACME = true;
        forceSSL = true;
        root = "/var/lib/doubleblind/sites/$host";
        useACMEHost = "science.tanneberger.me";
        #sslCertificate = (config.security.acme.certs."science.tanneberger.me".directory + "cert.pem");
      };

    };
  };

  dresden-zone.doubleblind = {
    enable = true;

    http = {
      host = "127.0.0.1";
      port = 7691;
    };
    database = {
      host = "127.0.0.1";
      port = config.services.postgresql.port;
      passwordFile = config.sops.secrets.postgres_password_doubleblind.path;
      user = "doubleblind";
      database = "doubleblind";
    };

    github = {
      clientID = "Iv1.35a8b170c19c4f62";
      passwordFileClientSecret = config.sops.secrets.github_client_secret.path;
      passwordFileHMACSecret = config.sops.secrets.github_hmac_secret.path;
      privateKeyFile = config.sops.secrets.github_private_key.path;
    };

    log_level = "debug";
  };
}
