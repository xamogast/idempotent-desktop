{ pkgs, ... }:

let
  id-error = pkgs.writeScriptBin "id-error" ''
    #!${pkgs.stdenv.shell}
    echo -e "\n💀\n"
  '';

  # https://stackoverflow.com/a/22102938
  # Get hex rgb color under mouse cursor, put it into clipboard and create a notification.
  id-pick-color = pkgs.writeScriptBin "id-pick-color" ''
    #!${pkgs.stdenv.shell}
    set -e

    eval $(xdotool getmouselocation --shell)
    IMAGE=`import -window root -depth 8 -crop 1x1+$X+$Y txt:-`
    COLOR=`echo $IMAGE | grep -om1 '#\w\+'`
    echo -n $COLOR | xclip -i -selection CLIPBOARD
    notify-send "Color under mouse cursor: " $COLOR
  '';

  id-build-iso = pkgs.writeScriptBin "id-build-iso" ''
    #!${pkgs.stdenv.shell}
    set -e

    nix build /etc/nixos#nixosConfigurations.live-usb.config.system.build.isoImage
  '';

  id-write-usb = pkgs.writeScriptBin "id-write-usb" ''
    #!${pkgs.stdenv.shell}
    set -e

    iso=$(id-build-iso)
    sudo dd bs=4M if=$iso/iso/id-live.iso of=/dev/disk/by-label/id-live status=progress oflag=sync
    # sudo dd bs=4M if=$img/sd-image/id-live-arm.iso.bz2 of=/dev/disk/by-label/id-live status=progress oflag=sync

    echo -e "\n💽\n"
  '';

  id-info = pkgs.writeScriptBin "id-info" ''
    #!${pkgs.stdenv.shell}

    LOCAL_IP=$(ip -o addr show | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $4}' | cut -d'/' -f 1)
    PUBLIC_IP=$(curl -s ifconfig.me)
    CPU=$(sudo lshw -short | grep -i processor | sed 's/\s\s*/ /g' | cut -d' ' -f3-)
    VIDEO=$(sudo lspci | grep -i --color 'vga\|3d\|2d' | cut -d' ' -f2-)

    echo -e "local: $LOCAL_IP, public: $PUBLIC_IP\n"
    echo -e "Processor: $CPU"
    echo -e "Video: $VIDEO\n"

    echo -e "\n"
    lsblk -f
    
    echo -e "\n"
    lsmod | rg kvm
  '';

  id-deploy = pkgs.writeScriptBin "id-deploy" ''
    #!${pkgs.stdenv.shell}
    set -e

    id-build-iso

    nix flake check
    nix-du --root /run/current-system/sw/ -s 100MB | tred | dot -Tsvg -Nfontname=Roboto -Efontname=Roboto > nix-store.svg

    iso=$(id-build-iso)
    du -h $iso/iso/id-live.iso
    rclone copy $iso/iso/id-live.iso gdrive:

    echo -e "\n🐗\n"
  '';

  # id-install <hostname>
  # id-install hk-47
  id-install = pkgs.writeScriptBin "id-install" ''
    #!${pkgs.stdenv.shell}
    set -e
    echo -e "\n🤖\n"
    
    sudo mount /dev/disk/by-label/nixos /mnt
    sudo mkdir -p /mnt/boot
    sudo mount /dev/disk/by-label/boot /mnt/boot/
    echo -e "\n💾"
    lsblk -f
    
    echo
    sudo git clone https://github.com/ksevelyar/idempotent-desktop.git /mnt/etc/nixos
    sudo chown -R 1000:1000 /etc/nixos/
    
    if [ -z "$1" ]
      then
        nixos-generate-config --root /mnt
        bat /mnt/etc/nixos/*.nix
      else
        cd /mnt/etc/nixos && ln -s hosts/$1 configuration.nix
    fi

    sudo ls -lah /etc/nixos/configuration.nix

    sudo nixos-install
    echo -e "\n🍈\n"
  '';

  id-random-wallpaper = pkgs.writeScriptBin "id-random-wallpaper" ''
    #!${pkgs.stdenv.shell}
    feh --randomize --bg-fill --no-fehbg ~/Wallpapers  
  '';

  id-tm = pkgs.writeScriptBin "id-tm" ''
    #!${pkgs.stdenv.shell}
    set -e

     if [ -z "$1" ]
      then
        tmux new -A -s 🦙
      else
        tmux new -A -s $1
    fi
  '';
in
{
  environment.systemPackages = [
    id-error
    id-info
    id-install

    id-build-iso
    id-write-usb

    id-pick-color
    pkgs.imagemagick

    id-deploy
    pkgs.rclone

    id-random-wallpaper
    id-tm
  ];
}
