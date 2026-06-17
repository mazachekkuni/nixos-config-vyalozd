{ pkgs, inputs, ... }:

{
  users.users.drfoobar.group = "drfoobar";
  home-manager.users.drfoobar = {
    home.stateVersion = "26.11";
    # import the home manager module
    imports = [
      inputs.noctalia.homeModules.default
    ];

    # configure options
    programs.noctalia-shell = {
      enable = true;
      plugins = {
        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];
        states = {
          catwalk = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };
          clipper = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins"; 
      };
    
        version = 2;
      };
      # this may also be a string or a path to a JSON file.

      pluginSettings = {
        catwalk = {
          minimumThreshold = 25;
          hideBackground = true;
        };
        # this may also be a string or a path to a JSON file.
      };
    };
  };
  services.upower.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
}

