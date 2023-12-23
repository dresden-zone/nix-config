{
  description = "dresden.zone nix flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
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
    doubleblind = {
      url = "github:dresden-zone/doubleblind.science";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, microvm, sops-nix, dns, dns-web, doubleblind }: {
    #packages."x86_64-linux".dresden-zone-microvm = self.nixosConfigurations.dresden-zone.config.microvm.declaredRunner;
    nixosConfigurations = {
      dresden-zone = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          microvm.nixosModules.microvm
          sops-nix.nixosModules.sops
          dns.nixosModules.chef
          dns.nixosModules.maid
          doubleblind.nixosModules.doubleblind
          ./modules/DresdenZone
          ./hosts/dresden-zone
          ./modules/dns
          {
            nixpkgs.overlays = [
              dns.overlays.default
              dns-web.overlays.default
              doubleblind.overlays.default
            ];
          }
        ];
      };
      hel1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs self; };
        modules = [
          sops-nix.nixosModules.sops
          #./modules/DresdenZone
          ./hosts/hel1
        ];
      };
    };
  };
}
