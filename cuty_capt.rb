class CutyCapt < Formula
  desc "Converts web pages to vector/bitmap images using WebKit"
  homepage "http://cutycapt.sourceforge.net/"
  url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/cutycapt/cutycapt_0.0~svn6.orig.tar.gz"
  version "0.0.6"
  sha256 "cf85226a25731aff644f87a4e40b8878154667a6725a4dc0d648d7ec2d842264"
  revision 1

  bottle do
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 "hashhere" => :sierra
    sha256 "hashhere" => :el_capitan
  end

  depends_on "cartr/qt4/qt@4"
  depends_on "cartr/qt4/qt-webkit@2.3"

  def install
    system "qmake", "CONFIG-=app_bundle"
    system "make"
    bin.install "CutyCapt"
  end

  test do
    system "#{bin}/CutyCapt", "--url=http://brew.sh", "--out=brew.png"
    assert File.exist? "brew.png"
  end
end
