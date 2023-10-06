{ pkgs, config, lib, ... }:
let
  regMotd = ''
      _____                    _              ______                
     |  __ \                  | |            |___  /                
     | |  | |_ __ ___  ___  __| | ___ _ __      / / ___  _ __   ___ 
     | |  | | '__/ _ \/ __|/ _` |/ _ \ '_ \    / / / _ \| '_ \ / _ \
     | |__| | | |  __/\__ \ (_| |  __/ | | |_ / /_| (_) | | | |  __/
     |_____/|_|  \___||___/\__,_|\___|_| |_(_)_____\___/|_| |_|\___|
      
      => Staging

  '';
  prodMotd = ''
      _____                    _              ______                
     |  __ \                  | |            |___  /                
     | |  | |_ __ ___  ___  __| | ___ _ __      / / ___  _ __   ___ 
     | |  | | '__/ _ \/ __|/ _` |/ _ \ '_ \    / / / _ \| '_ \ / _ \
     | |__| | | |  __/\__ \ (_| |  __/ | | |_ / /_| (_) | | | |  __/
     |_____/|_|  \___||___/\__,_|\___|_| |_(_)_____\___/|_| |_|\___|
                                                                    
      => Production                                                            
  '';
in
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    '';
    settings = {
      auto-optimise-store = true;
      experimental-features = "nix-command flakes";
    };
  };

  networking.useNetworkd = true;

  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "en_US/ISO-8859-1"
    "C.UTF-8/UTF-8"
  ];

  environment.systemPackages = with pkgs; [
    git
    htop
    tmux
    screen
    neovim
    wget
    git-crypt
    iftop
    tcpdump
    dig
  ];

  networking.firewall.enable = lib.mkDefault true;

  networking.firewall.allowedTCPPorts = [ 22 ];
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      ../../keys/ssh/revol-xut
      ../../keys/ssh/marcel
    ];
  };
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };
  programs.mosh.enable = true;

  users.motd = prodMotd;

  programs.screen.screenrc = ''
    defscrollback 10000

    startup_message off

    hardstatus on
    hardstatus alwayslastline
    hardstatus string "%w"
  '';
}
