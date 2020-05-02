{ pkgs, ... }:
{
  services.nfs.server.statdPort = 20000;
  services.nfs.server.lockdPort = 20001;
  services.nfs.server.mountdPort = 20002;

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
    };
  };

  services.mingetty.greetingLine = ''\l'';

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  services.journald.extraConfig = "SystemMaxUse=500M";

  services.fail2ban = {
    enable = true;
  };

  services.nixosManual.showManual = false;
}
