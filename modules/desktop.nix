{ pkgs, lib, ... }:
let
  slack = pkgs.slack.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      rm $out/bin/slack

      makeWrapper $out/lib/slack/slack $out/bin/slack \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
    '';
  });
in
{
  environment.systemPackages = with pkgs; [
    google-chrome
    chromium
    brave
    slack
    signal-desktop
    calibre
    zoom-us
    element-desktop
    koreader
  ];

  programs.firefox = {
    enable = true;
    languagePacks = [
      "de"
      "en-US"
      "en-GB"
      "hr"
    ];
  };

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "kkhfnlkhiapbiehimabddjbimfaijdhk" # gopass bridge
    ];
    extraOpts = {
      BraveRewardsDisabled = true;
      BraveWalletDisabled = true;
      BraveVPNDisabled = true;
      PasswordManagerEnabled = false;
      SpellcheckEnabled = true;
      SpellcheckLanguage = [
        "de"
        "en-US"
      ];
    };
  };
}
