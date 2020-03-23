# nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=/etx/nixos/iso.nix
# dd bs=4M if=result of=/dev/sdd status=progress oflag=sync


{config, pkgs, ...}:
{
  imports = [
    # <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # configure proprietary drivers
  nixpkgs.config.allowUnfree = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us,ru";
    xkbOptions = "grp:caps_toggle,grp:alt_shift_toggle,grp_led:caps";
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };

  services.redshift = {
    enable = true;
    temperature.night = 4000;
    temperature.day = 6500;
  };
  location.latitude = 55.75;
  location.longitude = 37.61;

  services.blueman.enable = true;
  services.tlp.enable = true;
  services.tlp.extraConfig = ''
     START_CHARGE_THRESH_BAT0=85
     STOP_CHARGE_THRESH_BAT0=95
     CPU_SCALING_GOVERNOR_ON_BAT=powersave
     ENERGY_PERF_POLICY_ON_BAT=powersave
   '';

  services.tor = {
    enable = true;
    client.enable = true;
  };

  services.nixosManual.showManual = true;
  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts # Microsoft free fonts
      opensans-ttf
      nerdfonts powerline-fonts
      ankacoder
    ];
  };
  networking.networkmanager.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      os-prober
      hwinfo
      wget curl
      neovim ripgrep

      # cli
      wtf

      mpv smplayer vlc kodi
      xbindkeys
      fzf
      gopass keepassxc
      firefoxWrapper
      google-chrome
      zathura
      dzen2
      memtest86-efi

      # Themes
      ant-theme
      arc-theme
      materia-theme
      paper-icon-theme
      lxappearance-gtk3
      skype feh
      transmission_gtk
      tdesktop
      mirage
      polybar
      xorg.xev

      # Audio
      google-play-music-desktop-player
      audacity lmms

      # Dev
      tldr nodejs
      elixir
      go
      terminator cool-retro-term kitty asciinema
      universal-ctags global
      gcc git gitg gitAndTools.diff-so-fancy lazygit
      imagemagick
      gimp

      # Freelance
      libreoffice
      masterpdfeditor

      # Sys
      memtest86plus

      ## fs
      mc spaceFM xfce.thunar
      ranger libcaca
      ncdu tree
      rsync
      sshfs
      ntfs3g exfat
      sshfsFuse

      lshw
      bat
      inetutils
      maim
      simplescreenrecorder
      smartmontools
      bind
      xmobar
      unzip
      xclip
      gotop iotop powertop
      rofi
      redshift
      bash
      tor-browser-bundle-bin
      pavucontrol
      libnotify dunst
      nixpkgs-fmt
      tightvnc

      # vncpasswd
      # x0vncserver -rfbauth ~/.vnc/passwd
      tigervnc

      steam
      mcomix
      neofetch

      # laptop
      arandr
      acpi
      ulauncher
      openssh

      winusb
    ];

    etc."xdg/gtk-3.0/settings.ini" = {
      text = ''
           [Settings]
           gtk-theme-name=Ant
           gtk-icon-theme-name=Paper-Mono-Dark
           gtk-font-name=Anka/Coder 13
           gtk-application-prefer-dark-theme = true
           gtk-cursor-theme-name=Paper
      '';
    };

    # usr."share/icons/default/index.theme" = {
    #   text = ''
    #     [icon theme]
    #     Inherits=Paper
    #     '';
    #   };

    etc."xdg/mimeapps.list" = {
      text = ''
             [Default Applications]
             inode/directory=spacefm.desktop

             x-scheme-handler/http=firefox.desktop
             x-scheme-handler/https=firefox.desktop
             x-scheme-handler/ftp=firefox.desktop
             x-scheme-handler/chrome=firefox.desktop
             text/html=firefox.desktop
             x-scheme-handler/unknown=firefox.desktop
      '';
    };

    etc."xdg/nvim/sysinit.vim".text = builtins.readFile ./init.vim;

    variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      BROWSER = "firefox";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.browserpass.enable = true;

  programs.fish.enable = true;
  programs.mosh.enable = true;
  programs.tmux.enable = true;

  programs.thefuck.enable = true; # https://github.com/nvbn/thefuck

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableAllFirmware = true;
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    opengl.driSupport32Bit = true;  # Required for Steam
    pulseaudio.support32Bit = true; # Required for Steam
    bluetooth.enable = true;
  };


  time.timeZone = "Europe/Moscow";

  users.defaultUserShell = pkgs.fish;

  nix.binaryCaches = [ "https://aseipp-nix-cache.global.ssl.fastly.net" ];
}