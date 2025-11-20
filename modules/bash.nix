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

      function set_win_title(){
        echo -ne "\033]0;''${USER}@''${HOSTNAME}: ''${PWD}\007"
      }
      starship_precmd_user_func="set_win_title"
    '';

    bashrcExtra =
      ''
        osc7_cwd() {
            local strlen=''${#PWD}
            local encoded=""
            local pos c o
            for (( pos=0; pos<strlen; pos++ )); do
                c=''${PWD:$pos:1}
                case "$c" in
                    [-/:_.!\'\(\)~[:alnum:]] ) o="''${c}" ;;
                    * ) printf -v o '%%%02X' "''${c}" ;;
                esac
                encoded+="''${o}"
            done
            printf '\e]7;file://%s%s\e\\' "''${HOSTNAME}" "''${encoded}"
        }
        PROMPT_COMMAND=''${PROMPT_COMMAND:+''${PROMPT_COMMAND%;}; }osc7_cwd
      '';

    sessionVariables = {
      LS_COLORS = "$(vivid generate gruvbox-dark-hard)";
    };
  };

  programs.direnv = {
    enable = true;
    direnvrcExtra = ''
      function use_standard-python() {
          source_up_if_exists
          dotenv_if_exists
          source_env_if_exists .envrc.local
          use venv
          uv sync
      }
    '';
  };
}
