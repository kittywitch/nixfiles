{ lib, buildFirefoxXpiAddon, ... }:

buildFirefoxXpiAddon {
  pname = "ff-sponsorblock";
  version = "2.0.13.1";
  sha256 = "0lq47xnpqqfa8md6l4f0rxxz1cz7hihv5grpqh3vdbvnsc90i6f9";
  addonId = "{99e84f4-839b-4494-b4ad-12ab59c51fbd}";
  url =
    "https://addons.mozilla.org/firefox/downloads/file/3748692/sponsorblock_skip_sponsorships_on_youtube-2.0.13.1-an+fx.xpi";

  meta = with lib; {
    homepage = "https://sponsor.ajay.app/";
    description =
      "Easily skip YouTube video sponsors. When you visit a YouTube video, the extension will check the database for reported sponsors and automatically skip known sponsors. You can also report sponsors in videos.";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
