# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = [ "zfs" ];
  };
  hardware = {
    enableRedistributableFirmware = true;
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
    trusted-substituters = [ "https://nix-community.cachix.org" ];
    trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    trusted-users = [ "@wheel" ];
  };

  # force builds to use nix deamon, also if user is root
  environment.variables = {
    NIX_REMOTE = "daemon";
    NIX_PATH = lib.mkForce "nixpkgs=${inputs.nixpkgs}";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
    };
  };
  services = {
    zfs = {
      autoSnapshot = {
        enable = true;
        frequent = 4;
        hourly = 7;
        daily = 6;
        weekly = 2;
        monthly = 1;
      };

      autoScrub = {
        enable = true;
      };
    };
  };
  boot = {
    tmp = {
      useTmpfs = true;
      cleanOnBoot = true;
    };

    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
    };

    initrd.network = {
      enable = true;
      ssh = {
        enable = true;
        port = 222;
        hostKeys = [ /etc/ssh/ssh_host_ed25519_key ];
        authorizedKeys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK255EY8KUx5cMXSuoERXJSzVnkDUM+y8sMAVrRoDBnn marcel" ];
      };
      postCommands = ''
        zpool import -a
        echo "zfs load-key -a; killall zfs" >> /root/.profile
      '';
    };
  };
  services = {
    openssh = {
      enable = true;
    };
  };

  networking.hostName = "hel1"; # Define your hostname.
  networking.hostId = "17900e62";
  networking.useDHCP = true;


  users.users = {
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK255EY8KUx5cMXSuoERXJSzVnkDUM+y8sMAVrRoDBnn marcel"
    ];
  };


  system.stateVersion = "23.11"; # Did you read the comment?

}

