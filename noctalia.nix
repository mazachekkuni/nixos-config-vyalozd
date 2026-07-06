{ pkgs, inputs, config, ... }:

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

      # Абсолютно вся конфигурация Noctalia v5 теперь пишется строго внутри settings
      settings = {
        # Базовые настройки шаблонов
        templates = {
          enableUserTemplates = true;
          activeTemplates = [
            { id = "spicetify"; active = true; }
          ];
        };

        # Настройки конкретных плагинов перенесены сюда
        pluginSettings = {
          catwalk = {
            minimumThreshold = 25;
            hideBackground = true;
          };
        };

        # Конфигурация плагинов v5 (внутри общего блока настроек)
        # Если вы хотите управлять ими декларативно, структура выглядит так:
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
