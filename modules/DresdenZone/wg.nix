{ lib, config, self, ... }:
let
  cfg = config.dresden-zone.net.wg;
in
{
  options.dresden-zone.net.wg = with lib; {

    ownEndpoint.host = mkOption {
      type = types.nullOr types.str;
      default = null;
    };
    ownEndpoint.port = mkOption {
      type = types.port;
      default = 51820;
    };

    publicKey = mkOption {
      type = types.str;
      default = "";
      description = "own public key";
    };
    privateKeyFile = mkOption {
      type = types.either types.str types.path;
    };
    addr4 = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    prefix4 = mkOption {
      type = types.int;
      default = 24;
      description = "network prefix";
    };

    extraPeers = mkOption {
      description = "extra peers that are not part of the deployment";
      type = types.listOf (types.submodule {
        options.addr4 = mkOption {
          type = types.str;
          description = "ip _without_ a network prefix";
        };
        options.publicKey = mkOption {
          type = types.str;
          description = "public key";
        };
      });
    };
  };

  config =
    let
      # move out as options?
      dd-zone-name = "wg-dd-zone";
      keepalive = 25;

      # helpers
      peer-systems = (lib.filter (x: (x.config.dresden-zone.net.wg.addr4 != cfg.addr4) && (!isNull x.config.dresden-zone.net.wg.addr4))
        (lib.attrValues self.nixosConfigurations));

      endpoint =
        let
          ep = (lib.filter
            (x:
              x.config.dresden-zone.net.wg.addr4 != cfg.addr4
              && (!isNull x.config.dresden-zone.net.wg.ownEndpoint.host))
            (lib.attrValues self.nixosConfigurations));
        in
        assert lib.assertMsg (lib.length ep == 1) "there should be exactly one endpoint"; ep;

      peers = map
        (x: {
          wireguardPeerConfig = {
            PublicKey = x.config.dresden-zone.net.wg.publicKey;
            AllowedIPs = [ "${x.config.dresden-zone.net.wg.addr4}/32" ];
            PersistentKeepalive = keepalive;
          };
        })
        peer-systems;

      ep = [{
        wireguardPeerConfig =
          let x = lib.elemAt endpoint 0; in {
            PublicKey = x.config.dresden-zone.net.wg.publicKey;
            AllowedIPs = [ "${x.config.dresden-zone.net.wg.addr4}/${toString cfg.prefix4}" ];
            Endpoint = with x.config.dresden-zone.net.wg.ownEndpoint; "${host}:${toString port}";
            PersistentKeepalive = keepalive;
          };
      }];

      # stuff proper
      dd-zone-netdev = {
        Kind = "wireguard";
        Name = dd-zone-name;
        Description = "TLMS enterprise, highly available, biocomputing-neural-network maintained, converged network";
      };

      dd-zone-wireguard = {
        PrivateKeyFile = cfg.privateKeyFile;
      } //
      (if !isNull cfg.ownEndpoint.host then { ListenPort = cfg.ownEndpoint.port; } else { });

      expeers = map
        (x: {
          wireguardPeerConfig = {
            PublicKey = x.publicKey;
            AllowedIPs = [ "${x.addr4}/32" ];
            PersistentKeepalive = keepalive;
          };
        })
        cfg.extraPeers;

      peerconf = if isNull cfg.ownEndpoint.host then ep else (peers ++ expeers);
    in
    lib.mkIf (!isNull cfg.addr4) {
      networking.wireguard.enable = true;

      networking.firewall.trustedInterfaces = [ dd-zone-name ];

      systemd.network.netdevs."30-${dd-zone-name}" = {
        netdevConfig = dd-zone-netdev;
        wireguardConfig = dd-zone-wireguard;
        wireguardPeers = peerconf;
      };
      systemd.network.networks."30-${dd-zone-name}" = {
        matchConfig.Name = dd-zone-name;
        networkConfig = {
          Address = "${cfg.addr4}/${toString cfg.prefix4}";
        };
      };
    };
}
