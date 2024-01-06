{ inputs, ... }:
{
  microvm = {
    vms = {
      my-microvm = {
        specialArgs = { inherit inputs; };
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

          dd-zone.enable = true;

          networking.useNetworkd = true;
          systemd.network.networks = {
            "10-lan" = {
              matchConfig.Type = "ether";
              addresses = [
                { addressConfig.Address = "10.44.1.2/24"; }
                { addressConfig.Address = "fd44:1::2/64"; }
              ];
              routes = [
                { routeConfig.Gateway = "10.44.1.1"; }
                { routeConfig.Gateway = "fd44:1::1"; }
              ];
              linkConfig.RequiredForOnline = "routable";
            };
          };
          services.openssh.enable = true;
          system.stateVersion = "23.11";
        };
      };
    };
  };
}

