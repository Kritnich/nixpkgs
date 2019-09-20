{ stdenv, fetchFromGitHub, openssl, qtbase, qtquickcontrols2, qmake, SDL2, ffmpeg,
  libva, libvdpau, libopus, libpulseaudio,
  alsaLib, SDL2_ttf, pkgconfig
}:

stdenv.mkDerivation rec {
  name = "moonlight-qt-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "moonlight-stream";
    repo = "moonlight-qt";
    rev = "v${version}";
    sha256 = "1118m0v2zrmavr7skibiqvhj4y1jz0vy0j33sd5d88azjc29v5w1";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake pkgconfig ];
  buildInputs = [ openssl qtbase qtquickcontrols2 SDL2 ffmpeg libva libvdpau libopus libpulseaudio alsaLib SDL2_ttf ];

  meta = with stdenv.lib; {
    description = "GameStream client for PCs (Windows, Mac, Linux, and Steam Link)";
    homepage = https://github.com/moonlight-stream/moonlight-qt;
    license = licenses.gpl3;
    maintainers = [ maintainers.kritnich ];
    platforms = platforms.linux;
  };
}
