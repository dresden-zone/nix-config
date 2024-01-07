{ ... }: {
  imports = [
    ./configuration.nix
    ./postgres.nix
    ./pgadmin.nix
  ];

  dd-zone = {
    enable = true;

    microvm = {
      enable = true;
      shares = true;
      site = "hel1";
      networking = {
        hostName = "postgres";
        lan = {
          mac = "2e:28:00:60:c2:1b";
          v4 = {
            addr = "10.44.1.2/24";
            gateway = "10.44.1.1";
          };
          v6 = {
            addr = "fd44:1::2/64";
            gateway = "fd44:1::1/64";
          };
        };
      };
    };

    acme = [{
      domainName = "hel1.dresden.zone";
      extraDomainNames = [ "*.hel1.dresden.zone" ];
    }];
  };
}
