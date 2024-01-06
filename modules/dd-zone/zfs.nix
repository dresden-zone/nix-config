{ lib, config, ... }:
let
  cfg = config.dd-zone;
in
{
  config = lib.mkIf cfg.modules.zfs {
    boot = {
      kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
      supportedFilesystems = [ "zfs" ];
    };

    services = {
      zfs = {
        autoSnapshot = {
          enable = true;
          frequent = 4;
          hourly = 7;
          daily = 6;
          weekly = 2;
          monthly = 1;
        };

        autoScrub = {
          enable = true;
        };
      };
    };
  };
}
