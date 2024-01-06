{ self, ... }: {
  microvm = {
    hypervisor = "cloud-hypervisor";
    mem = 2048;
    vcpu = 6;

    shares = [{
      source = "/nix/store";
      mountPoint = "/nix/.ro-store";
      tag = "ro-store";
      proto = "virtiofs";
    }];
  };

  services.openssh.enable = true;
  system.stateVersion = "23.11";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  sops.defaultSopsFile = self + /secrets/dresden-zone/secrets.yaml;
}
