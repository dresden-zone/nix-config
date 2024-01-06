{ ... }: {
  imports = [
    ./configuration.nix
  ];

  dd-zone = {
    enable = true;

    networking = {
      hostname = "postgres";
      v4 = {
        addr = "10.44.1.2/24";
        gateway = "10.44.1.1";
      };
      v6 = {
        addr = "fd44:1::2/64";
        gateway = "fd44:1::1/64";
      };
    };
  };
}
