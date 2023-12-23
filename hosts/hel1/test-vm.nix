{ ... }:
{
  microvm.vms = {
    my-microvm = {
      interfaces = [
        {
          type = "tap";
          id = "vm-test1";
          mac = "02:00:00:00:00:01";
        }
      ];

      config = {
        microvm.shares = [{
          source = "/nix/store";
          mountPoint = "/nix/.ro-store";
          tag = "ro-store";
          proto = "virtiofs";
        }];
      };
    };
  };
}
