{ lib, pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      minecraft-server = prev.minecraft-server.overrideAttrs (old: rec {
        version = "26.2"; # Replace with your desired version
        src = prev.fetchurl {
          url = "https://piston-data.mojang.com/v1/objects/823e2250d24b3ddac457a60c92a6a941943fcd6a/server.jar";

          # To get the correct hash, set this to lib.fakeHash, try to build,
          # and copy the correct hash from the error message.
          hash = "sha256-zazfsliY3l5LSw5d3MJyL3cGfkZgVwnC2IbAAOu2PsU=";
        };



        installPhase = ''
          runHook preInstall

          install -Dm644 $src $out/lib/minecraft/server.jar

          makeWrapper ${lib.getExe pkgs.openjdk25_headless} $out/bin/minecraft-server \
            --append-flags "-jar $out/lib/minecraft/server.jar nogui"
          runHook postInstall
        '';

      });
    })
  ];

  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true;
    declarative = true;

    serverProperties = {
      gamemode = "survival";
      difficulty = 1;
      max-players = 3;
      motd = "NixOS Minecraft server!";
      view-distance = 32;
      simulation-distance = 12;
    };
  };
}
