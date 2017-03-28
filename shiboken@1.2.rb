class ShibokenAT12 < Formula
  desc "C++ GeneratorRunner plugin for CPython extensions"
  homepage "https://wiki.qt.io/PySide"
  url "https://download.qt.io/official_releases/pyside/shiboken-1.2.2.tar.bz2"
  mirror "https://distfiles.macports.org/py-shiboken/shiboken-1.2.2.tar.bz2"
  sha256 "7625bbcf1fe313fd910c6b8c9cf49ac5495499f9d00867115a2f1f2a69fce5c4"

  head "https://github.com/PySide/Shiboken.git"

  bottle do
    root_url "https://dl.bintray.com/cartr/bottle-qt4"
    sha256 "71584344b25782198a432f4cd902ce8400cd9126e2e39c54387e713adc782069" => :sierra
    sha256 "415b42720142450db2b52e80d707b375ce0d7da168285222cc0b2c27e0415c52" => :el_capitan
    sha256 "d119f2d243fe7ffadde9821b3baa1385c3a5009b4dec36f0cee6cedb6d5c6442" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "cartr/qt4/qt@4"

  # don't use depends_on :python because then bottles install Homebrew's python
  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  def install
    # As of 1.1.1 the install fails unless you do an out of tree build and put
    # the source dir last in the args.
    Language::Python.each_python(build) do |python, version|
      mkdir "macbuild#{version}" do
        args = std_cmake_args
        # Building the tests also runs them.
        args << "-DBUILD_TESTS=ON"
        if python == "python3" && Formula["python3"].installed?
          python_framework = Formula["python3"].opt_prefix/"Frameworks/Python.framework/Versions/#{version}"
          args << "-DPYTHON3_INCLUDE_DIR:PATH=#{python_framework}/Headers"
          args << "-DPYTHON3_LIBRARY:FILEPATH=#{python_framework}/lib/libpython#{version}.dylib"
        end
        args << "-DUSE_PYTHON3:BOOL=ON" if python == "python3"
        args << ".."
        system "cmake", *args
        system "make", "install"
      end
    end
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import shiboken"
    end
  end
end
