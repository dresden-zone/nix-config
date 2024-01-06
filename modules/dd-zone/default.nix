{ lib, ... }:
{
  imports = [
    ./common.nix
    ./keymap.nix
    ./postgresql.nix
    ./zfs.nix
    #./microvm.nix
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
