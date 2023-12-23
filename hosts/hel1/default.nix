{ inputs, ... }: {
  imports = [
    inputs.microvm.nixosModules.host
    ./configuration.nix
    ./hardware-configuration.nix
    ./test-vm.nix
  ];
}
