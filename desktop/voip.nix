{ pkgs, ...  }:

{
  environment.systemPackages = with pkgs; [
    linphone
  ];
}
