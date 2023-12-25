{ ... }:
{
  microvm = {
    vms = {
      my-microvm = {
        config = {
          microvm = {
            mem = 1024;
            vcpu = 2;

            interfaces = [{
              type = "tap";
              id = "vm-test";
              mac = "2e:28:00:60:c2:1b";
            }];

            shares = [{
              source = "/nix/store";
              mountPoint = "/nix/.ro-store";
              tag = "ro-store";
              proto = "virtiofs";
            }];
          };

          networking.useNetworkd = true;
          systemd.network.networks = {
            "10-lan" = {
              matchConfig.Type = "ether";
              networkConfig = {
                DHCP = "ipv4";
                IPv6AcceptRA = true;
              };
              linkConfig.RequiredForOnline = "routable";
            };
          };
        };
      };
    };
  };
}
