class ShibokenAT12 < Formula
  desc "C++ GeneratorRunner plugin for CPython extensions"
  homepage "https://wiki.qt.io/PySide"
  url "https://download.qt.io/official_releases/pyside/shiboken-1.2.2.tar.bz2"
  mirror "https://distfiles.macports.org/py-shiboken/shiboken-1.2.2.tar.bz2"
  sha256 "7625bbcf1fe313fd910c6b8c9cf49ac5495499f9d00867115a2f1f2a69fce5c4"
  revision 1

  head "https://github.com/PySide/Shiboken.git"

  bottle do
    cellar :any
    rebuild 2
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 "5963a64fde67d897fa61735138a5038fbb85f65048a686aba0d6c7ae1c5565f1" => :high_sierra
    sha256 "4392a7a24506b1be9f640f1030cad073eb78877250de50ddcb237757cf9368cf" => :sierra
    sha256 "c3d4a78614c8d094237c6c44219b682bb96cded90188e59e6aa53ab1be883c3c" => :el_capitan
    sha256 "18fb05d0f912aa73acdccbc52a3fb4e74e86f8f905b0badd44149baaf72bb02e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "cartr/qt4/qt@4"

  # don't use depends_on :python because then bottles install Homebrew's python
  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on "python3" => :optional

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
