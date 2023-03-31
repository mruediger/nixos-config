{ pkgs, lib, ... }:
let
  user = import ../users/user.nix;
  toIni = lib.generators.toINI { };
in
{
  home.packages = with pkgs; [
    git-crypt
  ];

  programs = {
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
    git = {
      enable = true;
      diff-so-fancy = {
        enable = true;
      };
      userName = user.primary.name;
      userEmail = user.primary.email;
      aliases = {
        l = "log - -pretty=oneline --decorate --abbrev-commit --max-count=15";
        ll = "log --graph --pretty=format:'%Cred%h%Creset %an: %s %Creset%Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
        st = "status";
        c = "commit";
        ca = "commit --all";
        p = "push";
      };
      extraConfig = {
        init.defaultBranch = "main";
      };
      includes = [
        {
          path = "justwatch.inc";
          condition = "gitdir:~/src/justwatch/";
        }
      ];
    };
  };

  xdg.configFile."git/justwatch.inc".text = toIni {
    user = {
      userName = user.justwatch.name;
      userEmail = user.justwatch.email;
    };
    "url \"ssh://git@gitlab.justwatch.com\"" = {
      insteadOf = "https://jus.tw.cx";
    };
  };
}
