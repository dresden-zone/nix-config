{ inputs, config, lib, ... }:
{
  boot = {
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = [ "zfs" ];
  };

  hardware = {
    enableRedistributableFirmware = true;
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

  systemd.network = {
    netdevs."10-microvm".netdevConfig = {
      Kind = "bridge";
      Name = "microvm";
    };
    networks = {
      "10-lan" = {
        matchConfig.Name = "ens18";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "routable";
      };
      "10-microvm" = {
        matchConfig.Name = "microvm";
        networkConfig = {
          DHCPServer = true;
          IPv6SendRA = true;
        };
        addresses = [
          { addressConfig.Address = "10.77.1.1/24"; }
          { addressConfig.Address = "fdf7:f9b1:b566::1/64"; }
        ];
        ipv6Prefixes = [
          { ipv6PrefixConfig.Prefix = "fdf7:f9b1:b566::/64"; }
        ];
      };
    };
  };

  networking.useNetworkd = true;
  networking.hostName = "hel1"; # Define your hostname.
  networking.hostId = "17900e62";

  system.stateVersion = "23.11"; # Did you read the comment?
}

