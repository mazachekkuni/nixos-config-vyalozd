{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	
    ];
nixpkgs.config.allowUnfree = true;


nix.settings.experimental-features = [ "nix-command" "flakes" ];
nixpkgs.hostPlatform = "x86_64-linux";
programs.dconf.enable = true;
programs.nix-ld = {
  enable = true;
  libraries = [ pkgs.zlib pkgs.openssl ];
};
environment.sessionVariables = {

NIXOS_OZONE_WL = "1";
};
boot.loader = {
  efi.canTouchEfiVariables = true;
  grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    
    theme = inputs.nixos-grub-themes.packages.${pkgs.stdenv.hostPlatform.system}.nixos;
    };
  };
  boot.kernelParams = [
	"mem_sleep_default=deep"
	"atkbd.reset"
];
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/A7C2-CEB9";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  # Set your time zone.
   time.timeZone = "Europe/Kyiv";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n = {
   defaultLocale = "en_US.UTF-8";
   extraLocaleSettings = {
    LC_TIME = "en_GB.UTF-8";
  };
};
   console = {
     font = "Lat2-Terminus16";
    # keyMap = "us";
     useXkbConfig = true; # use xkb.options in tty.
   };

  # Enable the X11 windowing system.
   services.xserver.enable = true;
    services.displayManager.ly.enable = true;
     services.xserver.desktopManager.xfce.enable = true;

	programs.niri = {
    enable = true;
    package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
};

  # Battery
    #services.tlp.enable = true;
    services.power-profiles-daemon.enable = true;
    hardware.graphics = {
	enable = true;
	enable32Bit = true;
	extraPackages = with pkgs; [
	 ];
	};  
  # Configure keymap in X11
   services.xserver.xkb.layout = "us,ru,ua";
   services.xserver.xkb.options = "grp:alt_shift_toggle";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
   services.pipewire = {
     enable = true;
     pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
   services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.mazachekkuni = {

     isNormalUser = true;
     extraGroups = [ "wheel" "adbusers" "plugdev" ]; # Enable ‘sudo’ for the user.
     shell = pkgs.zsh;
     home = "/home/mazachekkuni";
     packages = with pkgs; [
       tree
     ];
  };
    #home-manager.users.mazachekkuni = { pkgs, ... }: {
    #home.packages = [ 
     # pkgs.tree 
     # pkgs.atool 
     # pkgs.httpie 
    #];


   # programs.home-manager.enable = true;

    #home.stateVersion = "26.11"; 
  #};
  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
  eval "$(direnv hook zsh)"
'';
  # cooler shit
   programs.steam = {
	enable = true;
	remotePlay.openFirewall = true; # Open ports for Steam Remote Play
	dedicatedServer.openFirewall = true;
     package = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [
      mangohud
      gamemode
    ];
   };
  };
   programs.thunar = {
  enable = true;
  plugins =  [
   pkgs.thunar-archive-plugin 
  ];
};
   users.users.drfoobar = {
    isNormalUser = true;
};
   users.groups.drfoobar = {};

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
   environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     brightnessctl
     git
     _64gram
     zed-editor
     noctalia-shell
     quickshell
     kdePackages.qtdeclarative
     kitty
     nautilus
     xwayland-satellite
     direnv
     nix-direnv
     gcc
     gh
     fastfetch
     file-roller
   ];

   

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}

