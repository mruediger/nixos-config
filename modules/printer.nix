{ pkgs, ... }:
{
  services.printing = {
    enable = true;
    startWhenNeeded = true;
    drivers = with pkgs; [
      gutenprint
      hplip
      brlaser
      mfc5890cncupswrapper
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_LaserJet_Pro_M148dw";
        ppdOptions = {
          PageSize = "A4";
          Duplex = "DuplexNoTumble";
        };
        # lpinfo -v  or   hp-setup -i  or   hp-makeuri <IP>
        #deviceUri = "hp:/net/HP_LaserJet_Pro_M148-M149";
        deviceUri = "hp:/usb/HP_LaserJet_Pro_M148-M149?serial=VNCNN10813";

        # lpinfo -m
        model = "HP/hp-laserjet_pro_m148-m149-ps.ppd.gz";
        description = "HP LaserJet Pro M148DW";
        location = "Wohnzimmer";
      }
      {
        name = "Brother_DCP-L2510";
        deviceUri = "usb://Brother/DCP-L2510D%20series?serial=E78274E1N234831";
        ppdOptions = {
          PageSize = "A4";
        };
        model = "drv:///brlaser.drv/brl2500d.ppd";
      }
      {
        name = "Brother_MFC-5890CN";
        deviceUri = "usb://Brother/MFC-5890CN?serial=BROL1F114846";
        ppdOptions = {
          PageSize = "A4";
        };
        model = "brmfc5890cn.ppd";
      }
    ];

    ensureDefaultPrinter = "HP_LaserJet_Pro_M148dw";
  };

  hardware.sane = {
    enable = true;
    brscan4.enable = true;
    extraBackends = with pkgs; [
      sane-airscan
      hplipWithPlugin
    ];
  };

  environment.systemPackages = with pkgs; [
    simple-scan
    xsane
    inkscape
  ];

  users.extraUsers.bag.extraGroups = [ "lp" "scanner" ];
}
