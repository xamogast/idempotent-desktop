{
  environment.shellAliases = {
    l = "ls -lahXF --group-directories-first";
    j = "z"; # autojump alias for z
    u = "aunpack";
    e = "sudo nvim /etc/nixos/configuration.nix";
    b = "sudo nixos-rebuild switch --keep-going";
    br = "sudo nixos-rebuild switch --keep-going && xmonad --restart";
    bu = "sudo nixos-rebuild switch --upgrade --keep-going --option connect-timeout 5";
    buf = "sudo nixos-rebuild switch --upgrade --keep-going --option connect-timeout 5 --fallback";
    t = "tmux new-session -A -s main";
    off = "sleep 0.5; xset dpms force off; pkill -f gpmdp";
    pgrep = "pgrep --full";
    pkill = "pkill --full";
    v = "nvim";
    g = "git";
    py_files_server = "python3 -m http.server 9000";
  };
}
