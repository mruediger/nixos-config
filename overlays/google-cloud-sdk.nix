self: super:
{
  google-cloud-sdk = super.google-cloud-sdk.overrideAttrs (attrs: {
    version = "281.0.0";
    src = self.fetchurl {
      url = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-281.0.0-linux-x86_64.tar.gz";
      sha256 = "00ziqr60q1la716c9cy3hjpyq3hiw3m75d4wry6prn5655jw4ph6";
    };
  });
}

