{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    latest.rustChannels.stable.rust
  ];

  environment.variables = {
    PATH = ["$HOME/.cargo/bin"];
  };

}
