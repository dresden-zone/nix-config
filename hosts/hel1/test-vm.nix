{ ... }:
{
  microvm = {
    vms = {
      my-microvm = {
        config = {
          microvm = {
            mem = 1024;
            vcpu = 2;
            hypervisor = "cloud-hypervisor";

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
              addresses = [
                { addressConfig.Address = "10.77.1.2/24"; }
                { addressConfig.Address = "fdf7:f9b1:b566::2/64"; }
              ];
              linkConfig.RequiredForOnline = "routable";
            };
          };
          system.stateVersion = "23.11";
        };
      };
    };
  };
}

