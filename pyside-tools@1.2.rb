class PysideToolsAT12 < Formula
  desc "PySide development tools (pyuic and pyrcc)"
  homepage "https://wiki.qt.io/PySide"
  url "https://github.com/PySide/Tools/archive/0.2.15.tar.gz"
  sha256 "8a7fe786b19c5b2b4380aff0a9590b3129fad4a0f6f3df1f39593d79b01a9f74"
  revision 1

  head "https://github.com/PySide/Tools.git"

  bottle do
    rebuild 2
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 cellar: :any, mojave:      "6eda5d9dc88477e751efb4d0985074e1163bfe42e48805f1f4a689b01fb230cf"
    sha256 cellar: :any, high_sierra: "ce1705c26ff37f14d9e2c8d89de2a1cd8d1285434fc762bc5f3473152d2b5664"
    sha256 cellar: :any, sierra:      "08e3186ed7c36de766daf475ca60146098a0858d66bedab77cd88c18ff07b80b"
    sha256 cellar: :any, el_capitan:  "96d0547e36fa48ddcc2f743909f0905b5aec03bd93bbde5409806aecc4a6c846"
    sha256 cellar: :any, yosemite:    "0d1c0c79a35dd143732af7998a94bb57b8ffa871fef11c05ffbd54c72ff6ec82"
  end

  depends_on "cmake" => :build
  depends_on "cartr/qt4/pyside@1.2"

  def install
    system "cmake", ".", "-DSITE_PACKAGE=lib/python2.7/site-packages", *std_cmake_args
    system "make", "install"
  end
end
