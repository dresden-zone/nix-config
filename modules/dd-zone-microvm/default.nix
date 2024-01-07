{ lib, config, ... }:
let
  cfg = config.dd-zone.microvm;
in
{
  imports = [
    ./networking.nix
    ./shares.nix
  ];

  options = {
    dd-zone.microvm = {
      enable = lib.mkEnableOption "Enable common dd-zone nix configuration.";
      site = lib.mkOption {
        type = lib.types.enum [ "hel1" "c3d2" ];
        description = "Site where the microvm is deployed.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
