class Valkyrie < Formula
  desc "GUI for Memcheck and Helgrind tools in Valgrind 3.6.X"
  homepage "http://valgrind.org/downloads/guis.html"
  url "http://valgrind.org/downloads/valkyrie-2.0.0.tar.bz2"
  sha256 "a70b9ffb2409c96c263823212b4be6819154eb858825c9a19aad0ae398d59b43"

  head "svn://svn.valgrind.org/valkyrie/trunk"

  depends_on "cartr/qt4/qt4"
  depends_on "valgrind"

  def install
    # Prevents "undeclared identifier" errors for getpid, usleep, and getuid.
    # Reported 21st Apr 2016 to https://bugs.kde.org/show_bug.cgi?id=362033
    inreplace "src/utils/vk_utils.h",
      "#include <iostream>",
      "#include <iostream>\n#include <unistd.h>"

    system "qmake", "PREFIX=#{prefix}"
    system "make", "install"
    prefix.install bin/"valkyrie.app"
  end

  test do
    assert_match version.to_s, shell_output("#{prefix}/valkyrie.app/Contents/MacOS/valkyrie -v 2>/dev/null")
  end
end
