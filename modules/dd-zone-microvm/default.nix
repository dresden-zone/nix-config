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
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
