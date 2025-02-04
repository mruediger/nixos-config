{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (texliveSmall.withPackages (
      ps: with ps; [
        marvosym
        droid
        xurl
        enumitem
        sectsty
        xstring
        xifthen
        ifmtarg
        lualatex-math
        roboto
        fontawesome5
        sourcesanspro
        tcolorbox
        environ
        tikzfill
        wrapfig
        capt-of
      ]
    ))
    pandoc
  ];
}
