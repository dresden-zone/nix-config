{ inputs, ... }: {
  imports = [
    inputs.sops-nix.nixosModules.sops
    inputs.microvm.nixosModules.host

    ../../common.nix

    ./configuration.nix
    ./hardware-configuration.nix
    ./test-vm.nix
  ];
}
