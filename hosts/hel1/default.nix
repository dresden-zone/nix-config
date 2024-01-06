{ inputs, ... }: {
  imports = [
    inputs.microvm.nixosModules.host

    ../../modules/common/common.nix
    ../../modules/common/zfs.nix
    ../../modules/common/sops.nix
    ../../modules/common/keymap.nix

    ./configuration.nix
    ./hardware-configuration.nix
    ./bird2.nix
    ./test-vm.nix
  ];
}
