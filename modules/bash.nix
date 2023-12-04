{ pkgs, lib, ... }:
{
  environment.variables = {
    PATH = [ "$HOME/bin" ];
  };

  home-manager.users.bag.programs.powerline-go = {
    enable = false;
    modules = [ "host" "nix-shell" "cwd" "git" "exit" ];
  };

  home-manager.users.bag.programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      add_newline = true;
      format = lib.strings.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$nix_shell"
        "$line_break"
        "$character"
      ];

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
      nix-search = "nix-env -qaP";
      nix-list = "nix-env -qaP \"*\" --description";
      ssh = "TERM=xterm-color ssh";
      gparted = "sudo -E gparted";
    };

    initExtra = ''
      eval "$(direnv hook bash)"
      bind "set completion-ignore-case on"
      bind "set completion-map-case on"
      bind "set show-all-if-ambiguous on"
      bind "set mark-symlinked-directories on"
    '';
  };



  #  programs.bash = {
  #    enableCompletion = true;
  #
  #    promptInit = ''
  #      if [ "$TERM" != "dumb" -o -n "$INSIDE_EMACS" ]; then
  #        normal="\[\e[0m\]"
  #        orange="\[\e[38;5;166m\]"
  #
  #        PS1="$orange\u$normal@\h:\w\n$orange>$normal "
  #      fi
  #    '';
  #
  #    interactiveShellInit = ''
  #      # Update window size after every command
  #      shopt -s checkwinsize
  #
  #      # Automatically trim long paths in the prompt (requires Bash 4.x)
  #      PROMPT_DIRTRIM=2
  #
  #      # Enable history expansion with space
  #      # E.g. typing !!<space> will replace the !! with your last command
  #      bind Space:magic-space
  #
  #      # Turn on recursive globbing (enables ** to recurse all directories)
  #      shopt -s globstar 2> /dev/null
  #
  #      # Case-insensitive globbing (used in pathname expansion)
  #      shopt -s nocaseglob
  #
  #      ## SMARTER TAB-COMPLETION (Readline bindings) ##
  #
  #      # Perform file completion in a case insensitive fashion
  #      bind "set completion-ignore-case on"
  #
  #      # Treat hyphens and underscores as equivalent
  #      bind "set completion-map-case on"
  #
  #      # Display matches for ambiguous patterns at first tab press
  #      bind "set show-all-if-ambiguous on"
  #
  #      # Immediately add a trailing slash when autocompleting symlinks to directories
  #      bind "set mark-symlinked-directories on"
  #
  #      ## SANE HISTORY DEFAULTS ##
  #
  #      # Append to the history file, don't overwrite it
  #      shopt -s histappend
  #
  #      # Save multi-line commands as one command
  #      shopt -s cmdhist
  #
  #      # Record each line as it gets issued
  #      PROMPT_COMMAND='history -a'
  #
  #      # Huge history. Doesn't appear to slow things down, so why not?
  #      HISTSIZE=500000
  #      HISTFILESIZE=100000
  #
  #      # Avoid duplicate entries
  #      HISTCONTROL="erasedups:ignoreboth"
  #
  #      # Don't record some commands
  #      export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"
  #
  #      # Use standard ISO 8601 timestamp
  #      # %F equivalent to %Y-%m-%d
  #      # %T equivalent to %H:%M:%S (24-hours format)
  #      HISTTIMEFORMAT='%F %T '
  #
  #      set bell-style none
  #
  #    '';
  #    shellAliases = {
  #      nix-search = "nix-env -qaP";
  #      nix-list = "nix-env -qaP \"*\" --description";
  #      ssh = "TERM=xterm-color ssh";
  #      gparted = "sudo -E gparted";
  #    };
  #  };
}
