class Coin < Formula
  desc "Retained-mode toolkit for 3D graphics development"
  homepage "https://bitbucket.org/Coin3D/coin/wiki/Home"
  url "https://bitbucket.org/Coin3D/coin/downloads/Coin-3.1.3.tar.gz"
  sha256 "583478c581317862aa03a19f14c527c3888478a06284b9a46a0155fa5886d417"

  bottle do
    root_url "https://homebrew.bintray.com/bottles"
    sha256 "f0f93e3c4a2b485866c9ec3a18931da88e86119854073c4e1c54ce93847f7f08" => :el_capitan
    sha256 "1b3e64aab7fe177f944b2ffcaccc3a068c992ebdd5f3047c15be513812797394" => :yosemite
    sha256 "db9f40c702a1b6955f23582988dcefd5866fa4d06589e4e16ec50ec11e64e87d" => :mavericks
  end

  option "without-soqt", "Build without SoQt"

  if build.with? "soqt"
    depends_on "pkg-config" => :build
    depends_on "cartr/qt4/qt@4"
  end

  resource "soqt" do
    url "https://bitbucket.org/Coin3D/coin/downloads/SoQt-1.5.0.tar.gz"
    sha256 "f6a34b4c19e536c00f21aead298cdd274a7a0b03a31826fbe38fc96f3d82ab91"
  end

  # https://bitbucket.org/Coin3D/coin/pull-request/3/missing-include/diff
  patch do
    url "https://bitbucket.org/cbuehler/coin/commits/e146a6a93a6b807c28c3d73b3baba80fa41bc5f6/raw"
    sha256 "6ecbd868ed574339b7fec3882e5fdccd40a60094800f9b5c081899091fdc3ab5"
  end

  def install
    # https://bitbucket.org/Coin3D/coin/issue/47 (fix misspelled test flag)
    inreplace "configure", "-fno-for-scoping", "-fno-for-scope"

    # https://bitbucket.org/Coin3D/coin/issue/45 (suppress math-undefs)
    # https://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/graphics/Coin/patches/patch-include_Inventor_C_base_math-undefs.h
    inreplace "include/Inventor/C/base/math-undefs.h", "#ifndef COIN_MATH_UNDEFS_H", "#if false"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-framework-prefix=#{frameworks}"
    system "make", "install"

    if build.with? "soqt"
      resource("soqt").stage do
        ENV.deparallelize

        # https://bitbucket.org/Coin3D/coin/issue/40#comment-7888751
        inreplace "configure", /^(LIBS=\$sim_ac_uniqued_list)$/, "# \\1"

        system "./configure", "--disable-debug",
          "--disable-dependency-tracking",
          "--with-framework-prefix=#{frameworks}",
          "--prefix=#{prefix}"

        system "make", "install"
      end
    end
  end
end
