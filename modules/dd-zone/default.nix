{ lib, config, ... }:
let
  cfg = config.dd-zone;
in
{
  options = {
    dd-zone = {
      enbale = lib.mkEnableOption "Enable common dd-zone nix configuration.";
      modules = {
        zfs = lib.mkEnableOption "Enable zfs nix configuration.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    imports = [
      ./common.nix
      ./keymap.nix
      ./postgres.nix
      ./sops.nix

      (lib.optional cfg.modules.zfs ./zfs.nix)
    ];
  };
}
