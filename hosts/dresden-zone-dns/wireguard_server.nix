{ config, ... }:
let
  port = 51820;
in
{
  sops.secrets.wg-seckey.owner = config.users.users.systemd-network.name;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;

  networking.firewall.allowedUDPPorts = [ port ];

  dresden-zone.net.wg = {
    ownEndpoint.host = "c3d2.hosts.dresden.zone";
    ownEndpoint.port = port;
    addr4 = "10.66.66.1";
    prefix4 = 24;
    privateKeyFile = config.sops.secrets.wg-seckey.path;
    publicKey = "WDvCObJ0WgCCZ0ORV2q4sdXblBd8pOPZBmeWr97yphY=";
    extraPeers = [
      {
        # Tassilo
        publicKey = "vgo3le9xrFsIbbDZsAhQZpIlX+TuWjfEyUcwkoqUl2Y=";
        addr4 = "10.66.66.2";
      }
      {
        # marcel
        publicKey = "Txd/qTDazvKcB1bIavm0Kilr/O7RkFwi9YGjjv88u2I=";
        addr4 = "10.66.66.3";
      }
    ];
  };
}
