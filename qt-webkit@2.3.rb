class QtWebkitAT23 < Formula
  desc "Qt port of WebKit (insecure, don't use for Web browsing)"
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
    use it if you don't absolutely trust the HTML files 
    you're using it to browse. Definely avoid using it
    in a general-purpose Web browser.
    
    Also, video doesn't work.
    EOS
  end
  
  bottle do
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 "6c5241ea53d8dd10484aac0c2eebcf332bfd8d19f529f35b3aa2797af9f38604" => :sierra
    sha256 "2e8cb144a5e72513e92d1878da71ba3e93fc84b3630a65b7e34d9a9189b35c08" => :el_capitan
  end
end
