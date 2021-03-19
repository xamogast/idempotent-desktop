{ config, lib, pkgs, ... }:
{
  system.stateVersion = "20.09";

  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>

      ../users/shared.nix
      ../users/ksevelyar.nix

      ../hardware/bluetooth.nix
      ../hardware/mouse.nix
      ../hardware/intel.nix
      ../hardware/nvidia.nix
      ../hardware/sound.nix
      ../hardware/ssd.nix

      ../sys/aliases.nix
      # ../sys/debug.nix
      ../sys/fonts.nix
      ../sys/nix.nix
      ../sys/scripts.nix
      ../sys/sysctl.nix
      ../sys/tty.nix
      ../sys/vars.nix

      ../boot/efi.nix
      ../boot/multiboot.nix
      # ../boot/plymouth.nix

      ../packages/absolutely-proprietary.nix
      ../packages/common.nix
      ../packages/x-common.nix
      ../packages/dev.nix
      ../packages/3d-print.nix
      ../packages/electronics.nix
      ../packages/firefox.nix
      # ../packages/games.nix
      ../packages/nvim.nix
      ../packages/pass.nix
      ../packages/tmux.nix
      ../packages/freelance.nix

      # ../services/flatpak.nix
      # ../services/mongodb.nix
      ../services/journald.nix
      ../services/postgresql.nix
      ../services/redis.nix
      ../services/x.nix
      ../services/x/picom.nix
      ../services/x/xmonad.nix
      ../services/x/redshift.nix

      # ../services/net/i2pd.nix
      # ../services/net/fail2ban.nix
      ../services/net/firewall-desktop.nix
      ../services/net/nginx.nix # id-doc
      ../services/net/openvpn.nix
      ../services/net/sshd.nix
      ../services/net/tor.nix
      ../services/net/wireguard.nix

      # ../services/vm/hypervisor.nix
      # ../services/vm/docker.nix
    ];

  # build arm from x64
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # nixpkgs.config.allowUnsupportedSystem = true;
  # nixpkgs.config.allowBroken = true;

  boot.kernelPackages = pkgs.linuxPackages_latest; # fix Cambridge Silicon Radio wi-fi dongles
  boot.loader.grub.splashImage = ../assets/displayManager.png;

  # boot
  boot.blacklistedKernelModules = [];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [];
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;

  # net
  networking.hostName = "hk47";
  networking.interfaces.enp4s0.useDHCP = true;
  networking.useDHCP = false;
  networking.firewall.enable = lib.mkForce true;
  networking.networkmanager.enable = false; # run nmtui for wi-fi

  networking.wireguard.interfaces = {
    skynet = {
      ips = [ "192.168.42.47" ];
      privateKeyFile = "/home/ksevelyar/wireguard-keys/private";

      peers = [
        {
          publicKey = "YruKx4tFhi+LfPgkhSp4IeHZD0lszSMxANGvzyJW4jY=";
          allowedIPs = [ "192.168.42.0/24" ];
          endpoint = "95.165.99.133:51821";
          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  # hardware
  ## i5-9400F
  ## PRIME B360M-K
  ## RTX 2060
  ## DIMM DDR4 2133MHz 16GBx2
  hardware = {
    pulseaudio.configFile = ../users/shared/disable-hdmi.pa;
  };

  services.xserver = {
    displayManager = {
      sessionCommands = ''
        nvidia-settings --assign CurrentMetaMode="nvidia-auto-select +0+0 { ForceCompositionPipeline=On, ForceFullCompositionPipeline=On }"
      '';
    };
  };

  # fs
  swapDevices = [];

  fileSystems."/" =
    {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "noatime" "nodiratime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "noatime" "nodiratime" ]; # ssd
    };

  fileSystems."/storage" =
    {
      device = "/dev/disk/by-label/storage";
      fsType = "ext4";
      options = [ "noatime" ];
    };

  fileSystems."/skynet" = {
    device = "192.168.42.1:/export";
    fsType = "nfs";

    # don't freeze system if mount point not available on boot
    options = [ "x-systemd.automount" "noauto" ];
  };
}
