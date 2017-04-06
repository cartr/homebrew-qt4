class PysideToolsAT12 < Formula
  desc "PySide development tools (pyuic and pyrcc)"
  homepage "https://wiki.qt.io/PySide"
  url "https://github.com/PySide/Tools/archive/0.2.15.tar.gz"
  sha256 "8a7fe786b19c5b2b4380aff0a9590b3129fad4a0f6f3df1f39593d79b01a9f74"
  revision 1

  head "https://github.com/PySide/Tools.git"

  bottle do
    root_url "https://dl.bintray.com/cartr/bottle-qt4"
    sha256 "a33526f4dfa462958cd9f193d7cb2b07890cb03f46a93c441010e54a9cbee061" => :sierra
    sha256 "2817916ec605546f4b0da37e4642f1383f2194e688c19d562a6888b9cef42de5" => :el_capitan
    sha256 "a9aeb98436fb100b7a2558aee7e08221a37a83cbe803e80149171c5d655a5208" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "cartr/qt4/pyside@1.2"

  def install
    system "cmake", ".", "-DSITE_PACKAGE=lib/python2.7/site-packages", *std_cmake_args
    system "make", "install"
  end
end
