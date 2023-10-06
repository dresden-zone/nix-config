{
  description = "dresden.zone nix flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, microvm, sops-nix}: {
    nixosConfigurations = {
      dresden-zone-dns = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs self; };
          modules = [
            microvm.nixosModules.microvm
            sops-nix.nixosModules.sops
            ./hosts/dresden-zone-dns
          ];
      };
    };
  };
}
