{ lib, buildPythonApplication, fetchFromGitHub, python3Packages }:

buildPythonApplication rec {
  pname = "bcnc";
  version = "0.9.14.304";

  src = fetchFromGitHub {
    owner = "vlachoudis";
    repo = pname;
    rev = version;
    sha256 = "1n92f6kjwkk8dhw6hxvgc6i7ijlc0590k2nd39sf83fszna3ak72";
  };
  
  doCheck = false;

  patchPhase = ''
    sed -ie '/opencv-python/d' setup.py
  '';

  propagatedBuildInputs = with python3Packages; [ numpy pillow opencv4 pyserial tkinter ];

  meta = with lib; {
    description = "GRBL CNC command sender, autoleveler and g-code editor";
    longDescription = ''
      GRBL CNC command sender, autoleveler, g-code editor, digitizer, CAM and swiss army knife for all your CNC needs.
      An advanced fully featured g-code sender for GRBL.
      bCNC is a cross platform program (Windows, Linux, Mac) written in python.
      The sender is robust and fast able to work nicely with old or slow hardware like Raspberry Pi (As it was validated by the GRBL maintainer on heavy testing).
    '';
    homepage = "https://github.com/vlachoudis/bCNC";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = maintainers.kritnich;
  };
}
