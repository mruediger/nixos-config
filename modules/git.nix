{ pkgs, lib, ... }:
let
  user = import ../users/user.nix;
in
{
  environment.systemPackages = with pkgs; [
    git-crypt
    gh
    pre-commit
  ];

  programs.git = {
    enable = true;
    config = {
      user = {
        name = user.primary.name;
        email = user.primary.email;
      };
      alias = {
        l = "log --pretty=oneline --decorate --abbrev-commit --max-count=15";
        ll = "log --graph --pretty=format:'%Cred%h%Creset %an: %s %Creset%Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
        st = "status";
        c = "commit";
        ca = "commit --all";
        p = "push";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
