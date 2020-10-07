{ stdenv, fetchurl, pkgconfig, vpnc, openssl ? null, gnutls ? null, gmp, libxml2, stoken, zlib, fetchgit, darwin } :

assert (openssl != null) == (gnutls == null);

stdenv.mkDerivation rec {
  pname = "openconnect";
  version = "8.10";

  src = fetchurl {
    urls = [
      "ftp://ftp.infradead.org/pub/openconnect/${pname}-${version}.tar.gz"
    ];
    sha256 = "1cdsx4nsrwawbsisfkldfc9i4qn60g03vxb13nzppr2br9p4rrih";
  };

  outputs = [ "out" "dev" ];

  configureFlags = [
    "--with-vpnc-script=${vpnc}/etc/vpnc/vpnc-script"
    "--disable-nls"
    "--without-openssl-version-check"
  ];

  buildInputs = [ openssl gnutls gmp libxml2 stoken zlib ]
    ++ stdenv.lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.PCSC;
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "VPN Client for Cisco's AnyConnect SSL VPN";
    homepage = "http://www.infradead.org/openconnect/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ pradeepchhetri tricktron ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
