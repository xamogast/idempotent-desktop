{ config, pkgs, lib, ... }:
{

  environment.systemPackages = with pkgs;
    let
      polybar = pkgs.polybar.override {
        pulseSupport = true;
      };
    in
      [
        alacritty
        firefoxWrapper
        tor-browser-bundle-bin
        zathura
        evince
        betterlockscreen
        spaceFM

        # themes
        lxappearance-gtk3
        vanilla-dmz
        ant-dracula-theme
        paper-icon-theme

        glxinfo
        feh
        transmission_gtk
        polybar
        xlsfonts
        xorg.xev
        xorg.xfontsel
        xorg.xfd

        # dev

        # sys
        keepassx-community
        system-config-printer
        maim
        simplescreenrecorder
        xclip
        rofi
        ulauncher
        pavucontrol
        libnotify
        dunst

        # media
        mpv
        imv
        nomacs

        # fs
        spaceFM

        gparted
        # vncpasswd
        # x0vncserver -rfbauth ~/.vnc/passwd
        tigervnc

        # laptop
        arandr
      ];

  programs.qt5ct.enable = true;
  # programs.slock.enable = true;

  services.picom = {
    enable = true;
    fade = false;
    shadow = false;
    backend = "glx";
    vSync = true;
  };

  environment.shellAliases = {
    x = "sudo systemctl start display-manager.service";
    xr = "sudo systemctl restart display-manager.service";
  };

  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "none+xmonad";
      sessionCommands = ''
        sh ~/.fehbg &
        xsetroot -cursor_name left_ptr
      '';
    };
    serverFlagsSection = ''
      Option "BlankTime" "0"
      Option "StandbyTime" "0"
      Option "SuspendTime" "0"
      Option "OffTime" "180"
    '';

    displayManager.lightdm = {
      enable = true;
      background = "/etc/nixos/assets/displayManager.png";

      greeters.gtk = {
        enable = true;
        cursorTheme = {
          name = "Vanilla-DMZ";
          package = pkgs.vanilla-dmz;
        };
      };
    };

    layout = "us,ru";
    xkbOptions = "grp:caps_toggle,grp:alt_shift_toggle,grp_led:caps";
    desktopManager = {
      xterm.enable = false;
    };

    windowManager = {
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
      xmonad.extraPackages = hpkgs: [
        hpkgs.xmonad-contrib
        hpkgs.xmonad-extras
        hpkgs.xmonad
      ];
    };
  };
}
