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

    dns = {
      url = "github:dresden-zone/dns";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dns-web = {
      url = "github:dresden-zone/dns-web";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, microvm, sops-nix, dns, dns-web }: {
    packages."x86_64-linux".dresden-zone-microvm = self.nixosConfigurations.dresden-zone.config.microvm.declaredRunner;
    nixosConfigurations = {
      dresden-zone = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          microvm.nixosModules.microvm
          sops-nix.nixosModules.sops
          dns.nixosModules.chef
          dns.nixosModules.maid
          ./hosts/dresden-zone
          ./modules/DresdenZone
          ./modules/dns
          {
            nixpkgs.overlays = [
              dns.overlays.default
              dns-web.overlays.default
            ];
          }
        ];
      };
    };
  };
}
