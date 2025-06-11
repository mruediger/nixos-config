;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nix-mode . ((compile-command . "nixos-rebuild switch --flake '.#'")
              (use-sudo-compile . t))))
