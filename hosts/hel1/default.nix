{ inputs, ... }: {
  imports = [
    inputs.microvm.nixosModules.host

    ../../common.nix
    ../../modules/zfs.nix
    ../../modules/sops.nix
    ../../modules/keymap.nix

    ./configuration.nix
    ./hardware-configuration.nix
    ./test-vm.nix
  ];
}
