{ pkgs, config, lib, inputs, ... }: {

  home.username = "mazachekkuni";
  home.homeDirectory = "/home/mazachekkuni";
  home.stateVersion = "26.11";
  
  
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic"; 
    size = 14;
  };


  
  targets.genericLinux.enable = true; 

   
  xdg.configFile."autostart/xfce4-notifyd.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';

  xdg.configFile."autostart/nm-applet.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';

  xdg.configFile."autostart/polkit-gnome-authentication-agent-1.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';
    xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  home.packages = with pkgs; [
    papirus-icon-theme
    kdePackages.breeze-icons
    gnome-themes-extra
    polkit_gnome
    eza
    zsh-powerlevel10k
    adwaita-qt
    adwaita-qt6
    qt6Packages.qtstyleplugin-kvantum
    supertuxkart
    oh-my-zsh
    kdePackages.ark
    nerd-fonts.jetbrains-mono
    playerctl
    deluge
    vesktop
    qt6.qtbase
    qt6.qttools
    inputs.helium.packages.${stdenv.hostPlatform.system}.default
    transmission_4-gtk
    anime4k
  ];


  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    #style.name = "adwaita-dark";
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    NIXOS_OZONE_HWP = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland"; # This stops the unstable branch XWayland fallback loop
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = [ "gnome" ];
};  
  dconf.settings = {
      "org/gnome/desktop/background" = {
        picture-uri-dark = "file://${pkgs.nixos-artwork.wallpapers.nineish-dark-gray.src}";
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };  
  gtk = {
    enable = true;
    
    gtk4.theme = null;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
   };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    iconTheme = {
      name = "YAMIS"; 
      package = pkgs.stdenv.mkDerivation {
        pname = "yamis-icon-theme";
        version = "latest";

        src = pkgs.fetchFromGitHub {
          owner = "googIyEYES";
          repo = "YAMIS";
          rev = "main";
          sha256 = "sha256-KZXG5XYHhUfgDrxOXT1mS+vbmH9l0uEzfdvOo1+r1TQ=";
        };

        dontBuild = true;

        installPhase = ''
          mkdir -p $out/share/icons
          tar -xvf monochrome-icon-theme.tar.gz -C $out/share/icons/
        '';
      };
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };
  };


  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    icons = "always";
  };

  fonts.fontconfig.enable = true;
 
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    history = {
      size = 1000;
      save = 1000; 
      path = "$HOME/.zsh_history";
    };

    shellAliases = {
      nixos-update = ''cd /etc/nixos && sudo nixos-rebuild switch --flake .#awesomebox --impure && cd'';
      commit = ''cd /etc/nixos && sudo git add . && sudo git commit -m "vyalozd" ; sudo git push origin main ; cd'';
	initContent = ''
 	 eval "$(direnv hook zsh)"
  '';
};
    setOptions = [
      "AUTO_CD"
    ];
    
    initContent = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "dirhistory" "history" ];
    };
  };
programs.direnv = {
  enable = true;
  nix-direnv.enable = true;
  config = {
    global = {
      log_format = "-";
      log_filter = "^$";
    };
  };
};

programs.mpv = {
  enable = true;

  scripts = with pkgs.mpvScripts; [
    uosc
    mpris
    thumbfast
  ];
  
  config = {
    hwdec = "auto";
    profile = "gpu-hq";
    vo = "gpu";
    osd-font = "JetBrainsMono Nerd Font";
    # Optimized shaders for lower-end GPU: Mode A (Fast)
    glsl-shaders="~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_M.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_S.glsl";
  };
  scriptOpts = {
    uosc = {
      osd-font = "JetBrainsMono Nerd Font"; 
    };
  };
};


  programs.home-manager.enable = true;

  programs.spicetify = let 
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}; 
  in {
    enable = true;
    spotifyLaunchFlags = "--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime";
    
  theme = spicePkgs.themes.comfy // {
  injectCss = true;
  replaceColors = true; 
  additionalCss = ''
    :root {
       --font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", monospace !important;
        --font-family-heading: "JetBrainsMono Nerd Font", "JetBrains Mono", monospace !important;
      }
      
      /* Brute-force override all elements in the UI */
      * {
        font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", monospace !important;
      }
    
  '';
  };
    
    colorScheme = "custom";
    
  customColorScheme = {
    text               = "e5e1e6";
    subtext            = "c8bfff";
    main               = "141316";
    sidebar            = "201f23";
    player             = "201f23";
    card               = "201f23";
    shadow             = "141316";
    selected-row       = "201f23";
    button             = "ffffff";
    button-active      = "c8bfff";
    button-disabled    = "2f2175";
    tab-active         = "c8bfff";
    notification       = "ffb4ab";
    notification-error = "ffb4ab";
    misc               = "2f2175";
    play-button        = "c8bfff";
    play-button-active = "c9cfff";
  };
   

    enabledExtensions = with spicePkgs.extensions; [
      shuffle 
      hidePodcasts
      
      adblock
    ];

    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];
  };

  programs.kitty = {
    enable = true;

    # 1. Main Keybindings Block
    keybindings = {
      "kitty_mod+k" = "send_text normal printf '\\\033[2J\\\033[3J\\\033[1;1H'";
      "ctrl+a" = "launch --type=clipboard --stdin-source=@screen_scrollback";
      "kitty_mod+enter" = "launch --cwd=current --type os-window";
      "ctrl+t" = "launch --cwd=current --type window";
      "kitty_mod+f" = "launch --type=overlay --stdin-source=@screen_scrollback /bin/sh -c \"/usr/bin/fzf --no-sort --no-mouse --exact -i --tac | kitty +kitten clipboard\"";
      "f1" = "toggle_marker itext 1 Exception";
      "f3" = "toggle_marker itext 1 Error";
      "f4" = "create_marker";
      "f5" = "remove_marker";
      "ctrl+alt+t" = "goto_layout tall";
      "ctrl+alt+f" = "goto_layout stack";
      "kitty_mod+e" = "kitten hints --type url --hints-text-color red";
      "kitty_mod+p" = "kitten hints --type=regex --regex=\"(?<path>(?:\\/[\\w-_^ ]+)+\\/?(?:[\\w.])+[^.]):\\[(?<line>\\d+),\\d+\\].?\" --program \"launch /home/madhur/scripts/editor.py\"";
      "kitty_mod+o" = "kitten hints --type hyperlink";
      "ctrl+[" = "layout_action decrease_num_full_size_windows";
      "ctrl+]" = "layout_action increase_num_full_size_windows";
      "ctrl+shift+t" = "launch --type=tab --cwd=current";
      "kitty_mod+right" = "next_tab";
      "kitty_mod+left" = "previous_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+tab" = "select_tab";
      "ctrl+left" = "resize_window narrower";
      "ctrl+right" = "resize_window wider";
      "ctrl+up" = "resize_window taller";
      "ctrl+down" = "resize_window shorter 3";
      "ctrl+home" = "resize_window reset";
      "kitty_mod+c" = "copy_to_clipboard";
      "ctrl+shift+f5" = "load_config_file";
      "cmd+c" = "copy_to_clipboard";
      "kitty_mod+v" = "paste_from_clipboard";
      "cmd+v" = "paste_from_clipboard";
      "kitty_mod+s" = "paste_from_selection";
      "shift+insert" = "paste_from_selection";
      "kitty_mod+l" = "next_layout";
      "kitty_mod+equal" = "change_font_size all +2.0";
      "kitty_mod+minus" = "change_font_size all -2.0";
      "kitty_mod+backspace" = "change_font_size all 0";
      "kitty_mod+]" = "next_window";
      "kitty_mod+[" = "previous_window";
      "kitty_mod+w" = "close_window";
      "alt+s" = "show_scrollback";
      "page_up" = "scroll_page_up";
      "page_down" = "scroll_page_down";
      "kitty_mod+home" = "scroll_home";
      "kitty_mod+end" = "scroll_end";
      "alt+shift+1" = "goto_tab 1";
      "alt+shift+2" = "goto_tab 2";
      "alt+shift+3" = "goto_tab 3";
      "alt+shift+4" = "goto_tab 4";
      "alt+shift+5" = "goto_tab 5";
      "alt+shift+6" = "goto_tab 6";
      "alt+shift+7" = "goto_tab 7";
      "alt+shift+8" = "goto_tab 8";
      "alt+shift+9" = "goto_tab 9";
      "alt+shift+0" = "goto_tab 10";
      "ctrl+shift+g" = "show_last_command_output";
      "ctrl+shift+z" = "scroll_to_prompt -1";
      "ctrl+shift+x" = "scroll_to_prompt 1";
    };

    # 2. Settings Block
    settings = {
      # Fonts
      font_family = "JetBrainsMono Nerd Font";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = "13.0";
      disable_ligatures = "always";
      text_composition_strategy = "legacy";

      # Window & Theme Options
      hide_window_decorations = "no";
      background_opacity = lib.mkForce "0.90";
      remember_window_size = "no";
      initial_window_width = 3840;
      initial_window_height = 1750;
      window_border_width = "0.5";
      window_padding_width = 0;
      confirm_os_window_close = 0;

      # Cursor & Scrollback
      cursor_shape = "beam";
      cursor_stop_blinking_after = 0;
      scrollback_lines = 300000;
      scrollback_pager = "nvim +\"source /home/madhur/.config/kitty/vi-mode.lua\"";

      # Mouse & Audio
      copy_on_select = "yes";
      enable_audio_bell = "no";
      visual_bell_duration = 0;
      window_alert_on_bell = "yes";
      bell_on_tab = "yes";

      # Layouts
      enabled_layouts = "tall,stack";

      # Tabs
      tab_bar_edge = "bottom";
      tab_bar_margin_width = "1.0";
      tab_bar_style = "separator";
      tab_bar_min_tabs = 2;
      tab_separator = "\"\"";
      tab_activity_symbol = "*";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      tab_title_template = "\"{fmt.fg._5c6370}{fmt.bg.default}{fmt.fg._abb2bf}{fmt.bg._5c6370} {fmt.fg.red}{activity_symbol}{fmt.fg._abb2bf}{index}: {title}{' [{}]'.format(num_windows) if num_windows > 1 else ''} {fmt.fg._5c6370}{fmt.bg.default} \"";
      active_tab_title_template = "\"{fmt.fg._282c34}{fmt.bg.default}{fmt.fg._abb2bf}{fmt.bg._282c34} {fmt.fg.red}{activity_symbol}{fmt.fg._abb2bf}{index}: {title}{' [{}]'.format(num_windows) if num_windows > 1 else ''} {fmt.fg._282c34}{fmt.bg.default} \"";

      # Shell Integration
      shell = "zsh --login";
      clear_all_shortcuts = "yes";
      kitty_mod = "ctrl+shift";
      term = "xterm-256color";
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";
      paste_actions = "quote-urls-at-prompt,confirm-if-large";
      shell_integration = "enabled";

      # URL rules
      detect_urls = "yes";
      url_style = "curly";
      url_prefixes = "http https file ftp gemini irc gopher mailto news git";

      # Notifications
      notify_on_cmd_finish = "invisible 10.0 notify";
    };

    # 3. Dynamic External Color Links
    extraConfig = ''
      include ~/.cache/wal/colors-kitty.conf
      include current-theme.conf
    '';
  };
programs.zed-editor = {
  enable = true;

  extraPackages = with pkgs; [
   llvmPackages.clang-tools
  ];

  # This populates the userSettings "auto_install_extensions"
  extensions = [ "nix" "toml" "elixir" "make" ];

  # Everything inside of these brackets are Zed options
  userSettings = {
    assistant = {
      enabled = true;
      version = "2";
      default_open_ai_model = null;
      
      default_model = {
        provider = "zed.dev";
        model = "claude-3-5-sonnet-latest";
      };
    };

    node = {
      path = lib.getExe pkgs.nodejs;
      npm_path = lib.getExe' pkgs.nodejs "npm";
    };

    hour_format = "hour24";
    auto_update = false;

    terminal = {
      alternate_scroll = "off";
      blinking = "off";
      copy_on_select = false;
      dock = "bottom";
      detect_venv = {
        on = {
          directories = [ ".env" "env" ".venv" "venv" ];
          activate_script = "default";
        };
      };
      env = {
        TERM = "alacritty";
      };
      font_family = "FiraCode Nerd Font";
      font_features = null;
      font_size = null;
      line_height = "comfortable";
      option_as_meta = false;
      button = false;
      shell = "system";
      toolbar = {
        title = true;
      };
      working_directory = "current_project_directory";
    }; # Закрывает terminal
  }; # Закрывает userSettings
}; # Закрывает programs.zed-editor
}
