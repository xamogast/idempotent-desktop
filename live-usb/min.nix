# nix build /etc/nixos#nixosConfigurations.live-usb-min.config.system.build.isoImage    

{ config, pkgs, lib, ... }:
{
  isoImage.volumeID = lib.mkForce "id-live-min";
  isoImage.isoName = lib.mkForce "id-live-min.iso";

  imports = [
    ../users/live-usb.nix

    ../sys/aliases.nix
    ../sys/scripts.nix
    ../sys/tty.nix
    ../sys/debug.nix
    ../sys/sysctl.nix

    ../packages/absolutely-proprietary.nix
    ../packages/common.nix
    ../packages/nvim.nix
    ../packages/tmux.nix
    ../packages/pass.nix

    ../hardware/broadcom-wifi.nix
    ../hardware/bluetooth.nix

    ../services/net/sshd.nix
    ../services/net/avahi.nix
  ];

  fonts.fonts = with pkgs;
    [
      terminus_font
      cozette
    ];

  networking.hostName = lib.mkForce "id-live-min";
  networking.networkmanager.enable = true; # nmtui for wi-fi
  networking.wireless.enable = lib.mkForce false;

  nix = {
    binaryCaches = [
      "https://idempotent-desktop.cachix.org"
    ];
    binaryCachePublicKeys = [
      "idempotent-desktop.cachix.org-1:OkWDud90b2/k/k1yIUg1lxZdNRWEvCfv6zSSRQ75lVM="
    ];
  };

  services.getty.helpLine = lib.mkForce ''
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
