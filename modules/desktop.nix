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
  user = import ../users/user.nix;
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
    gimp
    onlyoffice-desktopeditors
    libreoffice
  ];

  programs.firefox = {
    enable = true;
    languagePacks = [
      "de"
      "en-US"
      "en-GB"
      "hr"
    ];
    #https://raw.githubusercontent.com/corbindavenport/just-the-browser/main/firefox/policies.json
    policies = {
      "DisableFirefoxStudies" = true;
      "DisableTelemetry"= true;
      "DontCheckDefaultBrowser" = true;
      "FirefoxHome" = {
        "SponsoredStories" = false;
        "SponsoredTopSites" = false;
        "Stories" = false;
      };
      "GenerativeAI" = {
        "Enabled" = false;
      };
      "SearchEngines" = {
        "Default" = "DuckDuckGo";
        "Remove" = [
          "Perplexity"
        ];
      };
    };
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

  home-manager.users.bag = { config, ... }: {
    accounts.email.accounts."mailbox.org" = {
      primary = true;
      address = user.primary.mail_provider.address;
      userName = user.primary.mail_provider.userName;
      realName = user.primary.mail_provider.realName;
      flavor = "plain";

      aliases = user.primary.mail_provider.aliases;

      imap = {
        host = "imap.mailbox.org";
        port = 993;
        tls.enable = true;
      };

      smtp = {
        host = "smtp.mailbox.org";
        port = 465;
        tls.enable = true;
      };

      thunderbird = {
        enable = true;
        profiles = [ "default" ];
      };
    };

    programs.thunderbird = {
      enable = true;
      profiles.default = {
        isDefault = true;
        settings = {
          "mail.spellcheck.inline" = true;
          "spellchecker.dictionary" = "en-US,de-DE";
          "mailnews.start_page.enabled" = false;
        };
      };
    };
  };
}
