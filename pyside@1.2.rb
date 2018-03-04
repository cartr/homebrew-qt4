class PysideAT12 < Formula
  desc "Python bindings for Qt"
  homepage "https://wiki.qt.io/PySide"
  url "https://download.qt.io/official_releases/pyside/pyside-qt4.8+1.2.2.tar.bz2"
  mirror "https://distfiles.macports.org/py-pyside/pyside-qt4.8+1.2.2.tar.bz2"
  sha256 "a1a9df746378efe52211f1a229f77571d1306fb72830bbf73f0d512ed9856ae1"
  revision 2

  head "https://github.com/PySide/PySide.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "83f1da35b017aae67dfb0d414ea825b990c691c107c0a5f177f26252c15c684d" => :high_sierra
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 "51be3a1fd82789dfee8afd5079e01685ac480cacb3c07f9cdb839f4a695488ac" => :sierra
    sha256 "84303e789040c6fce89d499cb42308fd4a1d0f4ef7b8b5b760bf196e8c3e272a" => :el_capitan
    sha256 "ef5894f1769a3ca2e2c8b69eb8a8fc62daa0baf107e26d43a9bc3077394c14fc" => :yosemite
  end

  # don't use depends_on :python because then bottles install Homebrew's python
  option "without-python@2", "Build without python 2 support"
  depends_on "python@2" => :recommended if MacOS.version <= :snow_leopard
  depends_on "python" => :optional

  option "without-docs", "Skip building documentation"

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "cartr/qt4/qt@4"
  depends_on "cartr/qt4/qt-webkit@2.3"

  if build.with? "python"
    depends_on "cartr/qt4/shiboken@1.2" => "with-python"
  else
    depends_on "cartr/qt4/shiboken@1.2"
  end

  def install
    rm buildpath/"doc/CMakeLists.txt" if build.without? "docs"

    # Add out of tree build because one of its deps, shiboken, itself needs an
    # out of tree build in shiboken.rb.
    Language::Python.each_python(build) do |python, version|
      abi = `#{python} -c 'import sysconfig as sc; print(sc.get_config_var("SOABI"))'`.strip
      python_suffix = python == "python2.7" ? "-python2.7" : ".#{abi}"
      mkdir "macbuild#{version}" do
        qt = Formula["cartr/qt4/qt@4"].opt_prefix
        args = std_cmake_args + %W[
          -DSITE_PACKAGE=#{lib}/python#{version}/site-packages
          -DALTERNATIVE_QT_INCLUDE_DIR=#{HOMEBREW_PREFIX}/include
          -DQT_SRC_DIR=#{qt}/src
          -DPYTHON_SUFFIX=#{python_suffix}
        ]
        args << ".."
        system "cmake", *args
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "from PySide import QtCore"
    end
  end
end
