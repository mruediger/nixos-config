{ pkgs, lib, ... }:
{
  environment.variables = {
    PATH = [ "$HOME/bin" ];
  };

  environment.systemPackages = [
    pkgs.vivid
  ];

  home-manager.users.bag.programs.powerline-go = {
    enable = false;
    modules = [ "host" "nix-shell" "cwd" "git" "exit" ];
  };

  home-manager.users.bag.programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      format = lib.strings.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$nix_shell"
        "$line_break"
        "$character"
      ];

      directory = {
        truncate_to_repo = false;
        truncation_symbol = "...";
      };

      username = {
        show_always = true;
        format = "[$user]($style)@";
      };

      hostname = {
        ssh_only = false;
        format = "[$ssh_symbol$hostname]($style):";
      };
    };
  };

  home-manager.users.bag.programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    historyControl = [ "erasedups" ];
    historyFileSize = 100000;
    historySize = 100000;

    shellOptions = [
      "histappend"
      "checkwinsize" # Update window size after every command
      "extglob"
      "globstar"
      "checkjobs"
      "cmdhist"
    ];

    shellAliases = {
      gparted = "sudo -E gparted";
    };

    initExtra = ''
      eval "$(direnv hook bash)"
      bind "set completion-ignore-case on"
      bind "set completion-map-case on"
      bind "set show-all-if-ambiguous on"
      bind "set mark-symlinked-directories on"
    '';

    sessionVariables = {
      LS_COLORS = "$(vivid generate gruvbox-dark-hard)";
    };
  };

}
