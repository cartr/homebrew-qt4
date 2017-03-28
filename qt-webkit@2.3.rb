class QtWebkitAT23 < Formula
  desc "Qt port of WebKit (insecure, you shouldn't use it)"
  homepage "https://trac.webkit.org/wiki/QtWebKit"
  url "https://download.kde.org/stable/qtwebkit-2.3/2.3.4/src/qtwebkit-2.3.4.tar.gz"
  sha256 "c6cfa9d068f7eb024fee3f6c24f5b8b726997f669007587f35ed4a97d40097ca"

  depends_on "cartr/qt4/qt@4"

  def install
    ENV["QTDIR"] = Formula["cartr/qt4/qt@4"].opt_prefix
    system "Tools/Scripts/build-webkit", "--qt", "--no-webkit2", "--no-video", "--install-headers=#{include}", "--install-libs=#{lib}", "--minimal"
    system "make", "-C", "WebKitBuild/Release", "install"
  end

  def caveats; <<-EOS.undent
    This is years old and really insecure. You shouldn't
    use it, especially if you don't absolutely trust the
    HTML files you're using it to browse.
    
    Also, video doesn't work.
    EOS
  end
  
  bottle do
    root_url "https://dl.bintray.com/cartr/bottle-qt4"
    sha256 "5d7fcd5f7925ed4be7724aa2d1b8e14eef6e9cf786f362138e501c845ed0034f" => :sierra
    sha256 "933b11d7efbaa066f5ab75ec56e5319e1422dec940d5035b4242e9766d0555f1" => :el_capitan
    sha256 "63e5b332675a16fa7b13623dfa577cb49579d56b9fe43b2f8f04b0747a4ae80a" => :yosemite
  end
end
