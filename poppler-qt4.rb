class PopplerQt4 < Formula
  desc "PDF rendering library (based on the xpdf-3.0 code base)"
  homepage "https://poppler.freedesktop.org/"
  url "https://poppler.freedesktop.org/poppler-0.61.1.tar.xz"
  sha256 "1266096343f5163c1a585124e9a6d44474e1345de5cdfe55dc7b47357bcfcda9"

  option "with-little-cms2", "Use color management system"

  deprecated_option "with-lcms2" => "with-little-cms2"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openjpeg"
  depends_on "cartr/qt4/qt@4" => :optional
  depends_on "little-cms2" => :optional

  conflicts_with "pdftohtml", "pdf2image", "xpdf",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  resource "font-data" do
    url "https://poppler.freedesktop.org/poppler-data-0.4.8.tar.gz"
    sha256 "1096a18161f263cccdc6d8a2eb5548c41ff8fcf9a3609243f1b6296abdf72872"
  end

  needs :cxx11 if build.with?("qt@4") || MacOS.version < :mavericks

  def install
    ENV.cxx11 if build.with?("qt@4") || MacOS.version < :mavericks

    args = std_cmake_args + %w[
      -DENABLE_XPDF_HEADERS=ON
      -DENABLE_GLIB=ON
      -DBUILD_GTK_TESTS=OFF
      -DWITH_GObjectIntrospection=ON
      -DENABLE_QT5=OFF
    ]

    args << if build.with? "qt@4"
      "-DENABLE_QT4=ON"
    else
      "-DENABLE_QT4=OFF"
    end

    args << if build.with? "little-cms2"
      "-DENABLE_CMS=lcms2"
    else
      "-DENABLE_CMS=OFF"
    end

    system "cmake", ".", *args
    system "make", "install"
    resource("font-data").stage do
      system "make", "install", "prefix=#{prefix}"
    end

    libpoppler = (lib/"libpoppler.dylib").readlink
    ["#{lib}/libpoppler-cpp.dylib", "#{lib}/libpoppler-glib.dylib",
     *Dir["#{bin}/*"]].each do |f|
      macho = MachO.open(f)
      macho.change_dylib("@rpath/#{libpoppler}", "#{lib}/#{libpoppler}")
      macho.write!
    end
  end

  test do
    system "#{bin}/pdfinfo", test_fixtures("test.pdf")
  end
end
