{ self, ... }:
{
  sops.defaultSopsFile = self + /secrets/dresden-zone/secrets.yaml;

  microvm = {
    hypervisor = "cloud-hypervisor";
    mem = 2048;
    vcpu = 6;
  };

  system.stateVersion = "23.11";
}
