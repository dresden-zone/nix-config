{ self, ... }:
{
  sops.defaultSopsFile = self + /secrets/postgres-hel1/secrets.yaml;

  microvm = {
    hypervisor = "cloud-hypervisor";
    mem = 2048;
    vcpu = 6;
  };

  system.stateVersion = "23.11";
}
