class PysideTools < Formula
  desc "PySide development tools (pyuic and pyrcc)"
  homepage "https://wiki.qt.io/PySide"
  url "https://github.com/PySide/Tools/archive/0.2.15.tar.gz"
  sha256 "8a7fe786b19c5b2b4380aff0a9590b3129fad4a0f6f3df1f39593d79b01a9f74"

  head "https://github.com/PySide/Tools.git"

  bottle do
    root_url "https://dl.bintray.com/cartr/bottle-qt4"
    sha256 "8fca82bd423c0f2ed505480009e30b76065e1cc2758bed45b8a2523abb150ffe" => :sierra
    sha256 "f1513592aa38f8595825e2a339fd0cf4ab7ffbdd4cc71814291aa861ebbd5713" => :el_capitan
    sha256 "1f61192245b05946057f47d6a73788a998c86eefc846e1d09821a316c5bc2975" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "cartr/qt4/pyside"

  def install
    system "cmake", ".", "-DSITE_PACKAGE=lib/python2.7/site-packages", *std_cmake_args
    system "make", "install"
  end
end
