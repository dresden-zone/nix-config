{ self, ... }:
let
  mac_addr = "02:db:db:db:db:db";
in
{
  microvm = {
    hypervisor = "qemu";
    mem = 2048;
    vcpu = 6;
    interfaces = [{
      type = "tap";
      id = "serv-ddz-prod";
      mac = mac_addr;
    }];
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "store";
        proto = "virtiofs";
        socket = "store.socket";
      }
      {
        source = "/var/lib/microvms/dresden-zone-dns-prod/etc";
        mountPoint = "/etc";
        tag = "etc";
        proto = "virtiofs";
        socket = "etc.socket";
      }
      {
        source = "/var/lib/microvms/dresden-zone-dns-prod/var";
        mountPoint = "/var";
        tag = "var";
        proto = "virtiofs";
        socket = "var.socket";
      }
    ];
  };

  networking.hostName = "dresden-zone-dns"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  dresden-zone.net.iface.uplink = {
    name = "eth0";
    useDHCP = false;
    mac = mac_addr;
    matchOn = "mac";
    addr4 = "172.20.73.73/25";
    dns = [ "172.20.73.8" "9.9.9.9" ];
    routes = [
      {
        routeConfig = {
          Gateway = "172.20.73.1";
          Destination = "0.0.0.0/0";
        };
      }
    ];
  };


  sops.defaultSopsFile = self + /secrets/dresden-zone-dns/secrets.yaml;

  system.stateVersion = "23.05";
}
