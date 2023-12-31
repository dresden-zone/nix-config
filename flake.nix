{
  description = "dresden.zone nix flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    dns = {
      url = "github:dresden-zone/dns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns-web = {
      url = "github:dresden-zone/dns-web";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doubleblind = {
      url = "github:dresden-zone/doubleblind.science";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, microvm, sops-nix, dns, dns-web, doubleblind, ... }: {
    nixosConfigurations = {
      dns-c3d2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          microvm.nixosModules.microvm
          sops-nix.nixosModules.sops
          dns.nixosModules.chef
          dns.nixosModules.maid
          doubleblind.nixosModules.doubleblind
          ./modules/DresdenZone
          ./modules/dns
          ./hosts/dresden-zone
          {
            nixpkgs.overlays = [
              dns.overlays.default
              dns-web.overlays.default
            ];
          }
        ];
      };
      doubleblind-c3d2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          microvm.nixosModules.microvm
          sops-nix.nixosModules.sops
          doubleblind.nixosModules.doubleblind
          ./modules/DresdenZone
          ./modules/doubleblind
          ./hosts/doubleblind-c3d2
          {
            nixpkgs.overlays = [
              doubleblind.overlays.default
            ];
          }
        ];
      };
      postgres-hel1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          microvm.nixosModules.microvm
          sops-nix.nixosModules.sops
          ./modules/dd-zone
          ./modules/dd-zone-microvm
          ./hosts/postgres-hel1
        ];
      };
      hel1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          microvm.nixosModules.host
          sops-nix.nixosModules.sops
          ./modules/dd-zone
          ./hosts/hel1/default.nix
        ];
      };
    };
  };
}
