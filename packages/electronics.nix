{ config, pkgs, ... }:
{
  services.udev.packages = [ pkgs.stlink ];

  environment.systemPackages = with pkgs;
    [
      fritzing
      librepcb
      xoscope

      # platformio project init --ide vim --board bluepill_f103c8
      platformio

      # arduino
      # arduino --board arduino:avr:nano --port /dev/ttyUSB0 --upload shroom-box.ino
      # arduino
      # arduino-core

      # esp8266 / 32
      # esptool
      # nix-shell https://github.com/nix-community/nix-environments/archive/master.tar.gz -A arduino

      # stm32
      stlink
      openocd
      gcc-arm-embedded
      # stm32cubemx
      gnumake
      # python
    ];
}
