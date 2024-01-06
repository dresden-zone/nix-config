{ ... }:
{
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
        addresses = [
          { addressConfig.Address = "10.77.1.1/24"; }
          { addressConfig.Address = "fdf7:f9b1:b566::1/64"; }
        ];
        ipv6Prefixes = [
          { ipv6PrefixConfig.Prefix = "fdf7:f9b1:b566::/64"; }
        ];
      };
      "11-microvm" = {
        matchConfig.Name = "vm-*";
        # Attach to the bridge that was configured above
        networkConfig.Bridge = "microvm";
      };
    };
  };

  networking.useNetworkd = true;
  networking.hostName = "hel1"; # Define your hostname.
  networking.hostId = "17900e62";

  system.stateVersion = "23.11"; # Did you read the comment?
}

