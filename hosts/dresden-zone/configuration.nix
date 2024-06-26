{ self, ... }:
let
  mac_addr = "02:fe:fe:c3:d2:01";
in
{
  microvm = {
    hypervisor = "cloud-hypervisor";
    mem = 2048;
    vcpu = 4;
    interfaces = [
      {
        type = "tap";
        id = "serv-ddz-prod";
        mac = mac_addr;
      }
    ];
    shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "store";
        proto = "virtiofs";
        socket = "store.socket";
      }
      {
        source = "/var/lib/microvms/dresden-zone/etc";
        mountPoint = "/etc";
        tag = "etc";
        proto = "virtiofs";
        socket = "etc.socket";
      }
      {
        source = "/var/lib/microvms/dresden-zone/var";
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
    addr4 = "172.20.73.4/25";
    dns = [ "172.20.73.8" "9.9.9.9" ];
    routes = [
      {
        routeConfig = {
          Gateway = "45.158.40.160";
          Destination = "0.0.0.0/0";
        };
      }
    ];
  };


  #sops.defaultSopsFile = self + /secrets/dresden-zone/secrets.yaml;

  system.stateVersion = "23.11";
}
