{ pkgs, inputs, ... }:
{ pkgs, inputs, ... }:

{
  users.users.drfoobar.group = "drfoobar";
  
  home-manager.users.drfoobar = {
    home.stateVersion = "26.11";
    
    # Импорт модуля Home Manager для Noctalia
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;

      # Конфигурация плагинов и их версий (формат v5)
      plugins = {
        version = 2;
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
          clipper = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins"; 
          };
        }; # Закрывающая скобка для states теперь на месте
      };

      # Вся конфигурация поведения и плагинов теперь находится внутри settings
      settings = {
        templates = {
          enableUserTemplates = true;
          activeTemplates = [
            { id = "spicetify"; active = true; }
          ];
        };

        # Настройки конкретных плагинов (pluginSettings) перенесены сюда
        pluginSettings = {
          catwalk = {
            minimumThreshold = 25;
            hideBackground = true;
          };
        };
      };
    };
  };

  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.upower.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
}
