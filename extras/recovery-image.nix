{ config, lib, pkgs, flake, ... }:

with lib;

let
  cfg = config.boot.recoverySystem;
  recoverySystem = flake.recoveryBundle.${pkgs.system};
  recoveryPath = "/boot/recovery";
in {
  options.boot.recoverySystem = {
    enable = mkEnableOption "NixOS recovery system integration";
  };

  config = mkIf cfg.enable {
    system.activationScripts.installRecoveryImage = ''
      mkdir -p ${recoveryPath}
      cp ${recoverySystem}/kernel ${recoveryPath}/bzImage
      cp ${recoverySystem}/initrd ${recoveryPath}/initrd
    '';

    boot.loader.grub.extraEntries = ''
      menuentry "NixOS Recovery" {
        linux ${recoveryPath}/bzImage init=${recoverySystem}/init
        initrd ${recoveryPath}/initrd
      }
    '';

    # For systemd-boot
    boot.loader.systemd-boot.extraEntries = mkIf config.boot.loader.systemd-boot.enable {
      "recovery.conf" = ''
        title NixOS Recovery
        linux ${recoveryPath}/bzImage
        initrd ${recoveryPath}/initrd
        options init=${recoverySystem}/init
      '';
    };
  };
}
