class PysideAT12 < Formula
  desc "Python bindings for Qt"
  homepage "https://wiki.qt.io/PySide"
  url "https://download.qt.io/official_releases/pyside/pyside-qt4.8+1.2.2.tar.bz2"
  mirror "https://distfiles.macports.org/py-pyside/pyside-qt4.8+1.2.2.tar.bz2"
  sha256 "a1a9df746378efe52211f1a229f77571d1306fb72830bbf73f0d512ed9856ae1"

  head "https://github.com/PySide/PySide.git"

  bottle do
    root_url "https://dl.bintray.com/cartr/bottle-qt4"
    sha256 "b239f0b448538cbd20929e3f123a24bd2110fb5ea32d04d76f43c8e04f34d8d5" => :sierra
    sha256 "2dfd6a1c92af5baaab38348688fd4f439f85aea6122760caf435c58680ec3262" => :el_capitan
    sha256 "8513a36f424c936bbc3a8fcd61e593072c6a49ca0af8e50eba8fa4985cb9fdf9" => :yosemite
  end

  # don't use depends_on :python because then bottles install Homebrew's python
  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  option "without-docs", "Skip building documentation"

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "cartr/qt4/qt"

  if build.with? "python3"
    depends_on "cartr/qt4/shiboken@1.2" => "with-python3"
  else
    depends_on "cartr/qt4/shiboken@1.2"
  end

  def install
    rm buildpath/"doc/CMakeLists.txt" if build.without? "docs"

    # Add out of tree build because one of its deps, shiboken, itself needs an
    # out of tree build in shiboken.rb.
    Language::Python.each_python(build) do |python, version|
      abi = `#{python} -c 'import sysconfig as sc; print(sc.get_config_var("SOABI"))'`.strip
      python_suffix = python == "python" ? "-python2.7" : ".#{abi}"
      mkdir "macbuild#{version}" do
        qt = Formula["cartr/qt4/qt"].opt_prefix
        args = std_cmake_args + %W[
          -DSITE_PACKAGE=#{lib}/python#{version}/site-packages
          -DALTERNATIVE_QT_INCLUDE_DIR=#{qt}/include
          -DQT_SRC_DIR=#{qt}/src
          -DPYTHON_SUFFIX=#{python_suffix}
        ]
        args << ".."
        system "cmake", *args
        system "make"
        system "make", "install"
      end
    end

    inreplace include/"PySide/pyside_global.h", "#{HOMEBREW_CELLAR}/#{Formula["cartr/qt4/qt"].name}/#{Formula["cartr/qt4/qt"].pkg_version}",
       Formula["cartr/qt4/qt"].opt_prefix
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "from PySide import QtCore"
    end
  end
end
