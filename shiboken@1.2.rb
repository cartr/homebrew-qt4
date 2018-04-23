class ShibokenAT12 < Formula
  desc "C++ GeneratorRunner plugin for CPython extensions"
  homepage "https://wiki.qt.io/PySide"
  url "https://codeload.github.com/pyside/Shiboken/tar.gz/1.2.4"
  mirror "https://distfiles.macports.org/py-shiboken/Shiboken-1.2.4.tar.gz"
  sha256 "1536f73a3353296d97a25e24f9554edf3e6a48126886f8d21282c3645ecb96a4"

  head "https://github.com/PySide/Shiboken.git"

  bottle do
    cellar :any
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 "dc505b7f9571ec2ca8f81bf335b3e45066e24069e29a68c45c8966a6698bd44e" => :high_sierra
    sha256 "0b1ab8320d7ff126e323aec0bed3a8d388daad0986159bc69fcf04fcfb84694e" => :sierra
    sha256 "ce7187223847c8becf32edb0bf462cfe40c90b69a68336f2f338d461c5645ac1" => :el_capitan
    sha256 "cc2533d0f3393e429468d75663d0f4a92dcaba4912b0b9aa85212a3d89b9a36b" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "cartr/qt4/qt@4"

  # don't use depends_on :python because then bottles install Homebrew's python
  option "without-python@2", "Build without python 2 support"
  depends_on "python@2" => :recommended if MacOS.version <= :snow_leopard
  depends_on "python" => :optional

  def install
    # As of 1.1.1 the install fails unless you do an out of tree build and put
    # the source dir last in the args.
    Language::Python.each_python(build) do |python, version|
      mkdir "macbuild#{version}" do
        args = std_cmake_args
        # Building the tests also runs them.
        args << "-DBUILD_TESTS=ON"
        if python == "python3" && Formula["python"].installed?
          python_framework = Formula["python"].opt_prefix/"Frameworks/Python.framework/Versions/#{version}"
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
