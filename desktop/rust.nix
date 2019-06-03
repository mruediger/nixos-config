{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
#    latest.rustChannels.stable.rust
    latest.rustChannels.nightly.rust
    latest.rustChannels.nightly.rust-src
  ];

  environment.variables = {
    PATH = ["$HOME/.cargo/bin"];
  };

}
