{ pkgs, config, ... }: {
  sops.secrets."env_secret_doubleblind".owner = "postgres";
  sops.secrets.github_token.owner = config.dresden-zone.doubleblind.user;

  security.acme.certs."science.tanneberger.me" = {
    webroot = null;
    dnsProvider = "inwx";
    credentialsFile = config.sops.secrets."env_secret_doubleblind".path;
    extraDomainNames = [ "*.science.tanneberger.me" ];
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
        locations."/" = {
          root = "${pkgs.doubleblind-frontend}/bin/";
          index = "index.html";
        };
      };
      "api.science.tanneberger.me" = {
        enableACME = true;
        locations."/" = {
          proxyPass = with config.dresden-zone.doubleblind.http; "http://${host}:${toString port}";
        };
      };

      #"~^(?<domain>[^.]+)\.science\.tanneberger\.me$" = {
      #enableACME = true;
      #forceSSL = true;
      #  root = "/var/lib/doubleblind/sites/$domain";
      #};
      #"*.doubleblind.science" = {
      #  #enableACME = true;
      #  forceSSL = true;
      #  root = "/var/lib/doubleblind/sites/$host";
      #  useACMEHost = "science.tanneberger.me";
        #sslCertificate = (config.security.acme.cets."science.tanneberger.me".directory + "cert.pem");
      #};

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
      clientID = "8ada4145996bcf0b40ee";
      passwordFile = config.sops.secrets.github_token.path;
    };
  };
}
