{ self, pkgs, ... }:
{
  sops.defaultSopsFile = self + /secrets/dresden-zone/postgres-hel1.yaml;

  microvm = {
    hypervisor = "cloud-hypervisor";
    mem = 2048;
    vcpu = 6;
  };

  environment.systemPackages = with pkgs; [ ifstate ];

  system.stateVersion = "23.11";
}
