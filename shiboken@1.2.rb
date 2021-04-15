class ShibokenAT12 < Formula
  desc "C++ GeneratorRunner plugin for CPython extensions"
  homepage "https://wiki.qt.io/PySide"
  url "https://codeload.github.com/pyside/Shiboken/tar.gz/1.2.4"
  mirror "https://distfiles.macports.org/py-shiboken/Shiboken-1.2.4.tar.gz"
  sha256 "1536f73a3353296d97a25e24f9554edf3e6a48126886f8d21282c3645ecb96a4"

  head "https://github.com/PySide/Shiboken.git"

  bottle do
    root_url "https://dl.bintray.com/cartr/autobottle-qt4"
    sha256 cellar: :any, mojave:      "9ee4301c0fb346c05db64e1b83575dd5f545f5e6a5995d93c24bac1128209914"
    sha256 cellar: :any, high_sierra: "9fc153a21d3cabf6c7a996c0147b8341dafc5c631b43cb1a085ecf2dbee4ce25"
    sha256 cellar: :any, sierra:      "f886aa8e05466368ab49d7396250f5ea08ee1ece1f2285470b4bb4789042e893"
    sha256 cellar: :any, el_capitan:  "a81c6f85b893e75b34c624d82519c0ead1b537320922064f71fb8a841d4d8d6b"
    sha256 cellar: :any, yosemite:    "e7fcd71f74a0018ee43463323248042e8bfdafd927b303ce00a53d88846cfac4"
  end

  option "without-python@2", "Build without python 2 support"

  depends_on "cmake" => :build
  depends_on "cartr/qt4/qt@4"

  # don't use depends_on :python because then bottles install Homebrew's python
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
