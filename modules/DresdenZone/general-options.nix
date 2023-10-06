{ lib, ... }:
with lib; {
  options = {
    dresden-zone.systemNumber = mkOption {
      type = types.int;
      default = 0;
      description = "number of the system";
    };

    dresden-zone.domain = mkOption {
      type = types.str;
      default = "tlm.solutions";
      description = "domain the server is running on";
    };
  };
}


