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

    networking.hostName = cfg.networking.hostName;

    networking.ifstate = {
      enable = true;
      settings = {
        interfaces = [{
          name = "eth0";
          addresses = [
            cfg.networking.lan.v4.addr
            cfg.networking.lan.v6.addr
          ];
          link = {
            state = "up";
            kind = "physical";
            address = cfg.networking.lan.mac;
          };
        }];
        routing.routes = [
          { to = "10.44.0.0/16"; via = cfg.networking.lan.v4.gateway; }
          { to = "fd44::/16"; via = cfg.networking.lan.v6.gateway; }
        ];
      };
    };
  };
}
