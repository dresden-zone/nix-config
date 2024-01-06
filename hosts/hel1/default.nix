{ inputs, ... }: {
  imports = [
    inputs.microvm.nixosModules.host

    ./configuration.nix
    ./hardware-configuration.nix
    ./bird2.nix
    ./test-vm.nix
  ];

  dd-zone = {
    enable = true;
    modules.zfs = true;
  };
}
