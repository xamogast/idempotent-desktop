# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=/etc/nixos/live-usb.nix -o live-usb
# sudo dd bs=4M if=live-usb/iso/nixos.iso of=/dev/sdc status=progress && sync

{ config, pkgs, lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-base.nix>
    ./modules/absolutely-proprietary.nix
    ./modules/aliases.nix
    ./modules/scripts.nix
    ./modules/services.nix
    ./modules/debug.nix

    ./modules/x.nix
    ./modules/fonts.nix
    # ./modules/fonts-high-dpi.nix
    ./modules/bluetooth.nix
    ./modules/sound.nix

    ./modules/common-packages.nix
    # ./modules/extra-packages.nix
    # ./modules/dev-packages.nix
    # ./modules/games.nix

    ./modules/laptop.nix
    ./users/live-usb.nix
  ];

  # isoImage.splashImage = /etc/nixos/assets/grub.png;
  isoImage.volumeID = lib.mkForce "nixos-maxi";
  isoImage.isoName = lib.mkForce "nixos.iso";

  # Whitelist wheel users to do anything
  # This is useful for things like pkexec or gparted
  #
  # WARNING: this is dangerous for systems
  # outside the installation-cd and shouldn't
  # be used anywhere else.
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  services.xserver = {
    autorun = false;
    displayManager.lightdm = {
      autoLogin = { enable = true; user = "mrpoppybutthole"; };
    };
  };

  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  networking.networkmanager.enable = true;
  networking.wireless.enable = lib.mkForce false;

  nix.binaryCaches = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];

  services.mingetty.helpLine = lib.mkForce ''
    The "root" account has "jkl" password.
    Type `x' to start the graphical user interface.
    Type `i' to print system information.

    .     .       .  .   . .   .   . .    +  .
      .     .  :     .    .. :. .___---------___.
           .  .   .    .  :.:. _".^ .^ ^.  '.. :"-_. .
        .  :       .  .  .:../:            . .^  :.:\.
            .   . :: +. :.:/: .   .    .        . . .:\
     .  :    .     . _ :::/:               .  ^ .  . .:\
      .. . .   . - : :.:./.                        .  .:\
      .      .     . :..|:                    .  .  ^. .:|
        .       . : : ..||        .                . . !:|
      .     . . . ::. ::\(                           . :)/
     .   .     : . : .:.|. ######              .#######::|
      :.. .  :-  : .:  ::|.#######           ..########:|
     .  .  .  ..  .  .. :\ ########          :######## :/
      .        .+ :: : -.:\ ########       . ########.:/
        .  .+   . . . . :.:\. #######       #######..:/
          :: . . . . ::.:..:.\           .   .   ..:/
       .   .   .  .. :  -::::.\.       | |     . .:/
          .  :  .  .  .-:.":.::.\             ..:/
     .      -.   . . . .: .:::.:.\.           .:/
    .   .   .  :      : ....::_:..:\   ___.  :/
       .   .  .   .:. .. .  .: :.:.:\       :/
         +   .   .   : . ::. :.:. .:.|\  .:/|
         .         +   .  .  ...:: ..|  --.:|
    .      . . .   .  .  . ... :..:.."(  ..)"
     .   .       .      :  .   .: ::/  .  .::\
  '';
}
