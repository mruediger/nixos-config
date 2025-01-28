{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (texliveSmall.withPackages (
      ps: with ps; [
        marvosym
        droid
      ]
    ))
    pandoc
  ];
}
