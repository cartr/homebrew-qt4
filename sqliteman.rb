class Sqliteman < Formula
  desc "GUI tool for Sqlite3"
  homepage "http://www.sqliteman.com/"
  url "https://downloads.sourceforge.net/project/sqliteman/sqliteman/1.2.2/sqliteman-1.2.2.tar.bz2"
  sha256 "2f3281f67af464c114acd0a65f05b51672e9f5b39dd52bd2570157e8f274b10f"

  bottle do
    root_url "https://homebrew.bintray.com/bottles"
    sha256 "58aa529353dad48607eb46064df44aadea49887eb20d0df01f46452a48e48689" => :el_capitan
    sha256 "872ac20b5090d3f91ca3cb3c518e1d318876dc5d616c1fe1e49afafa1e601c58" => :yosemite
    sha256 "69313b1b3a7d480ab6ce4b3b544c8f0c1ea1b7128a834a82a98be97dc0344a9a" => :mavericks
  end

  depends_on "cmake" => :build

  depends_on "cartr/qt4/qt"
  depends_on "qscintilla2"

  def install
    mkdir "build" do
      qsci_include = Formula["qscintilla2"].include
      qsci_cmake_arg = "-DQSCINTILLA_INCLUDE_DIR=#{qsci_include}/Qsci"
      system "cmake", "..", qsci_cmake_arg, *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/sqliteman", "--langs"
  end
end
