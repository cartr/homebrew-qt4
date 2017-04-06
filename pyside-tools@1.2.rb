class PysideToolsAT12 < Formula
  desc "PySide development tools (pyuic and pyrcc)"
  homepage "https://wiki.qt.io/PySide"
  url "https://github.com/PySide/Tools/archive/0.2.15.tar.gz"
  sha256 "8a7fe786b19c5b2b4380aff0a9590b3129fad4a0f6f3df1f39593d79b01a9f74"
  revision 1

  head "https://github.com/PySide/Tools.git"

  bottle do
    cellar :any
    rebuild 1
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 "e8455fad485ac4cd5df83344afebe1ef64c02c10eb713f93ca248840570c7148" => :sierra
    sha256 "145a6f69bd958a09b06675efe945ee7806b3c70814aceab522e66663709a1c56" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "cartr/qt4/pyside@1.2"

  def install
    system "cmake", ".", "-DSITE_PACKAGE=lib/python2.7/site-packages", *std_cmake_args
    system "make", "install"
  end
end
