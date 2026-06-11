{ pkgs, inputs, ... }:

{
  # Додаємо пакет Noctalia з головного флейка у систему
  environment.systemPackages = [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Вмикаємо обов'язкові сервіси для роботи системних toggles (Wi-Fi, батарея, Bluetooth)
  services.upower.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
}

