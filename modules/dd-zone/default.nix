{ lib, config, ... }:
let
  cfg = config.dd-zone;
in
{
  imports = [
    ./common.nix
    ./keymap.nix
    ./postgresql.nix
    ./sops.nix

    #(lib.optional cfg.modules.zfs ./zfs.nix)
  ];
  options = {
    dd-zone = {
      enable = lib.mkEnableOption "Enable common dd-zone nix configuration.";
      modules = {
        zfs = lib.mkEnableOption "Enable zfs nix configuration.";
      };
    };
  };
}
