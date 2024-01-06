{ lib, config, ... }:
let
  cfg = config.dd-zone.microvm;
in
{
  options = {
    dd-zone.microvm = {
      networking = {
        hostName = lib.mkOption {
          type = lib.types.str;
          description = "Hostname of the microvm.";
        };
        site = lib.mkOption {
          type = lib.types.enum [ "hel1" "c3d2" ];
          description = "Site where the microvm is deployed.";
        };
        lan = {
          mac = lib.mkOption {
            type = lib.types.str;
            description = "Mac address of the microvm.";
          };
          v4 = {
            addr = lib.mkOption {
              type = lib.types.str;
              description = "Ipv4 address of the microvm.";
            };
            gateway = lib.mkOption {
              type = lib.types.str;
              description = "Ipv4 gateway of the microvm.";
            };
          };
          v6 = {
            addr = lib.mkOption {
              type = lib.types.str;
              description = "Ipv6 address of the microvm.";
            };
            gateway = lib.mkOption {
              type = lib.types.str;
              description = "Ipv6 gateway of the microvm.";
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    microvm.interfaces = [{
      type = "tap";
      id = "vm-${cfg.networking.hostName}";
      mac = cfg.networking.lan.mac;
    }];

    networking.useNetworkd = true;
    networking.hostName = cfg.networking.hostName;

    systemd.network.networks = {
      "10-lan" = {
        matchConfig.MACAddress = cfg.networking.lan.mac;
        addresses = [
          { addressConfig.Address = cfg.networking.lan.v4.addr; }
          { addressConfig.Address = cfg.networking.lan.v6.addr; }
        ];
        routes = [
          { routeConfig.Gateway = cfg.networking.lan.v4.gateway; }
          { routeConfig.Gateway = cfg.networking.lan.v6.gateway; }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
