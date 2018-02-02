class QtLegacyFormula < Formula
  desc "Cross-platform application and UI framework"
  homepage "https://www.qt.io/"
  url "https://github.com/cartr/placeholder-repo/releases/download/999.0.0/placeholder-repo-999.0.0.tar.gz"
  sha256 "6166c138bfc80564e793fbc41c39b5e9e4c41ce4724fdba12396fbfed0887d3f"

  depends_on "cartr/qt4/qt-webkit@2.3" => :recommended
  depends_on "cartr/qt4/qt@4"
  
  deprecated_option "without-webkit" => "without-qt-webkit@2.3"

  def install
    opoo <<~EOS
    At the request of Homebrew maintainers, the Qt 4 formula has been
    renamed from `qt` to `qt@4`. You may need to re-run qmake/cmake and
    recompile any software that uses Qt 4.
    
    If you wrote a script/package/formula that installs Qt 4, consider 
    find-replacing "cartr/qt4/qt" with "cartr/qt4/qt-webkit@2.3" if you
    need Webkit support or "cartr/qt4/qt@4" if you don't.
    
    
    EOS
    
    system "touch", "temp file uninstall qt-legacy-formula to remove"
    bin.install "temp file uninstall qt-legacy-formula to remove"
  end
end
