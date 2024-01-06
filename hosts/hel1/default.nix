{ inputs, ... }: {
  imports = [
    inputs.microvm.nixosModules.host

    ../../common.nix
    ../../modules/zfs.nix
    ../../modules/sops.nix
    ../../modules/keymap.nix

    ./configuration.nix
    ./hardware-configuration.nix
    ./bird2.nix
    ./test-vm.nix
  ];
}
