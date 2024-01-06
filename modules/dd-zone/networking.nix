{ lib, config, ... }:
let
  cfg = config.dd-zone.networking;
in
{
  options = {
    dd-zone.networking = {
      enable = lib.mkEnableOption "Enable common dd-zone nix configuration.";
      hostname = lib.mkOption {
        type = lib.types.str;
        description = "Hostname of the microvm.";
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

  config = lib.mkIf cfg.enable {
    networking.useNetworkd = true;

    systemd.network.networks = {
      "10-lan" = {
        matchConfig.Type = "ether";
        addresses = [
          { addressConfig.Address = cfg.v4.addr; }
          { addressConfig.Address = cfg.v6.addr; }
        ];
        routes = [
          { routeConfig.Gateway = cfg.v4.gateway; }
          { routeConfig.Gateway = cfg.v6.gateway; }
        ];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  };
}
