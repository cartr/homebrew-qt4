class PysideAT12 < Formula
  desc "Python bindings for Qt"
  homepage "https://wiki.qt.io/PySide"
  url "https://codeload.github.com/pyside/PySide/tar.gz/1.2.4"
  mirror "https://distfiles.macports.org/py-pyside/PySide-1.2.4.tar.gz"
  sha256 "90f2d736e2192ac69e5a2ac798fce2b5f7bf179269daa2ec262986d488c3b0f7"

  head "https://github.com/PySide/PySide.git"

  bottle do
    cellar :any
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 "c3a85d2ad28306550cc8e844ad53edd9b7756e6643f8b80b2231354c8e016f35" => :mojave
    sha256 "fae1f0246101547c9646f3bcee32c21ae006530398c812a97496c13c6ffa12ec" => :high_sierra
    sha256 "b905f9edacee0b937c7873b6e53815121776b3c9c4a6baa21522dce94fa2675f" => :sierra
    sha256 "98861a66bf700f7c38b44471b933062a285bcbdd238e17499a8beb50545115f1" => :el_capitan
    sha256 "c3016b818ac01bb8e93164e398dc3dfb645a99932741d8508e6369972f32c1cf" => :yosemite
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
