class PysideToolsAT12 < Formula
  desc "PySide development tools (pyuic and pyrcc)"
  homepage "https://wiki.qt.io/PySide"
  url "https://github.com/PySide/Tools/archive/0.2.15.tar.gz"
  sha256 "8a7fe786b19c5b2b4380aff0a9590b3129fad4a0f6f3df1f39593d79b01a9f74"
  revision 1

  head "https://github.com/PySide/Tools.git"

  bottle do
    cellar :any
    rebuild 2
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 "08e3186ed7c36de766daf475ca60146098a0858d66bedab77cd88c18ff07b80b" => :sierra
    sha256 "96d0547e36fa48ddcc2f743909f0905b5aec03bd93bbde5409806aecc4a6c846" => :el_capitan
    sha256 "0d1c0c79a35dd143732af7998a94bb57b8ffa871fef11c05ffbd54c72ff6ec82" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "cartr/qt4/pyside@1.2"

  def install
    system "cmake", ".", "-DSITE_PACKAGE=lib/python2.7/site-packages", *std_cmake_args
    system "make", "install"
  end
end
