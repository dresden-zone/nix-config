{ lib, config, inputs, ... }:
let
  cfg = config.dd-zone;
in
{
  imports = [
    (lib.optional cfg.microvm.host inputs.microvm.nixosModules.host)
  ];
}
