{ ... }: {
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./bird2.nix
  ];

  dd-zone = {
    enable = true;
    modules.zfs = true;
  };
}
