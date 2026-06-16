{ pkgs, inputs, ... }:

{
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  services.upower.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
}

