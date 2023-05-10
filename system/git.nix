{ pkgs, lib, ... }:
let
  user = import ../users/user.nix;
in
{
  environment.systemPackages = with pkgs; [
    git-crypt
  ];

  programs.git = {
    enable = true;
    config = {
      user = {
        name = user.primary.name;
        email = user.primary.email;
      };
      aliases = {
        l = "log - -pretty=oneline --decorate --abbrev-commit --max-count=15";
        ll = "log --graph --pretty=format:'%Cred%h%Creset %an: %s %Creset%Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
        st = "status";
        c = "commit";
        ca = "commit --all";
        p = "push";
      };
      init = {
        defaultBranch = "main";
      };
      includeIf = {
        "gitdir:~/src/justwatch/" = {
          path = "gitconfig_justwatch";
        };
      };
    };
  };

  environment.etc.gitconfig_justwatch.text = lib.generators.toGitINI {
    user = {
      userName = user.justwatch.name;
      userEmail = user.justwatch.email;
    };
    url = {
      "ssh://git@gitlab.justwatch.com" = {
        insteadOf = [ "https://jus.tw.cx" ];
      };
    };
  };
}
