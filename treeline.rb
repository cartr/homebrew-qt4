class Treeline < Formula
  desc "Advanced outliner and personal information manager"
  homepage "http://treeline.bellz.org/"
  url "https://downloads.sourceforge.net/project/treeline/2.0.2/treeline-2.0.2.tar.gz"
  sha256 "80379b6ebb5b825a02f4b8d0bb65d78f9895db5e25065f85353833e9d8ebd4c8"
  revision 2

  depends_on "cartr/qt4/pyqt@4" => "with-python"
  depends_on "python"
  depends_on "sip" => "with-python"

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.delete "PYTHONPATH"
    %w[sip pyqt].each do |f|
      ENV.append_path "PYTHONPATH", "#{Formula[f].opt_lib}/python#{pyver}/site-packages"
    end

    system "./install.py", "-p#{libexec}"
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    system bin/"treeline", "--help"
  end
end
