{ lib, config, ... }:
let
  cfg = config.dd-zone.microvm;
in
{
  options = {
    dd-zone.microvm.shares = lib.mkEnableOption "Enable common dd-zone nix configuration.";
  };

  config = lib.mkIf cfg.shares {
    microvm.shares = [
      {
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
        tag = "store";
        proto = "virtiofs";
        socket = "store.socket";
      }
      {
        source = "/var/lib/microvms/${config.networking.hostname}/etc";
        mountPoint = "/etc";
        tag = "etc";
        proto = "virtiofs";
        socket = "etc.socket";
      }
      {
        source = "/var/lib/microvms/${config.networking.hostname}/var";
        mountPoint = "/var";
        tag = "var";
        proto = "virtiofs";
        socket = "var.socket";
      }
    ];
  };
}
