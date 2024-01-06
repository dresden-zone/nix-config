{ config, pkgs, pkgs-unstable, inputs, ... }:

{
  services.xserver.layout = "de";

  console = {
    keyMap = "de";
    # would require services.xserver.enable = true
    # useXkbConfig = true;
  };
}

