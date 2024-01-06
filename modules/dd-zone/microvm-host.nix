{ lib, config, inputs, ... }:
let
  cfg = config.dd-zone;
in
{
  imports = lib.mkIf cfg.microvm.host [
    inputs.microvm.nixosModules.host
  ];
}
