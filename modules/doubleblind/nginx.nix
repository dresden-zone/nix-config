{ pkgs, config, ... }: {
  security.acme = {
    acceptTerms = true;
    defaults.email = "certs@dresden.zone";
  };
}
