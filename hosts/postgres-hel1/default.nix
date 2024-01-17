{ ... }: {
  imports = [
    ./configuration.nix
    ./postgres.nix
    # ./pgadmin.nix
  ];

  networking.useDHCP = false;
  networking.useNetworkd = false;
  systemd.network.enable = false;

  microvm.interfaces = [{
    type = "tap";
    id = "vm-postgres";
    mac = "2e:28:00:60:c2:1b";
  }];

  networking.ifstate = {
    enable = true;
    settings = {
      interfaces = [{
        name = "eth0";
        addresses = [
          "10.44.1.2/24"
          "fd44:1::2/64"
        ];
        link = {
          state = "up";
          kind = "physical";
          address = "2e:28:00:60:c2:1b";
        };
      }];
      routing = {
        routes = [
          {
            to = "0.0.0.0/0";
            via = "10.44.1.1";
          }
          {
            to = "fd44::/16";
            via = "fd44:1::1";
          }
        ];
      };
    };
  };
  dd-zone = {
    enable = true;

    microvm = {
      enable = true;
      shares = true;
      site = "hel1";
      networking = {
        hostName = "postgres";
        #          lan = {
        #            mac = "2e:28:00:60:c2:1b";
        #            v4 = {
        #              addr = "10.44.1.2/24";
        #              gateway = "10.44.1.1";
        #            };
        #            v6 = {
        #              addr = "fd44:1::2/64";
        #              gateway = "fd44:1::1/64";
        #            };
      };
    };

    acme = [{
      domainName = "hel1.dresden.zone";
      extraDomainNames = [ "*.hel1.dresden.zone" ];
    }];
  };
}
