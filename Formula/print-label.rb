class PrintLabel < Formula
  include Language::Python::Virtualenv

  desc "Thermal printer label maker for Bluetooth cat printers"
  homepage "https://github.com/francofrizzo/utilities"
  url "https://github.com/francofrizzo/utilities/archive/refs/tags/label-v0.3.0.tar.gz"
  sha256 "c9f87801768e040dc00ed21781517c1272660421606778f5f91ddcaa155391cb"
  license "MIT"

  depends_on "python@3.13"

  resource "bleak" do
    url "https://files.pythonhosted.org/packages/45/8a/5acbd4da6a5a301fab56ff6d6e9e6b6945e6e4a2d1d213898c21b1d3a19b/bleak-2.1.1.tar.gz"
    sha256 "4600cc5852f2392ce886547e127623f188e689489c5946d422172adf80635cf9"
  end

  def install
    venv = virtualenv_create(libexec, "python3.13")

    resource("bleak").stage do
      venv.pip_install Pathname.pwd
    end

    venv.pip_install buildpath/"label"

    # Link the entry point to bin
    (bin/"print-label").write_env_script(libexec/"bin/print-label", PATH: "#{libexec}/bin:$PATH")
  end

  def post_install
    system libexec/"bin/python", "-m", "pip", "install", "--quiet",
           "Pillow", "numpy", "opencv-python"
  end

  def caveats
    <<~EOS
      Print a label:
        print-label "PANKO"
        print-label "BREAD CRUMBS" --subtext "Japanese Style"

      See all options:
        print-label --help
    EOS
  end

  test do
    assert_match "Print labels on thermal printer", shell_output("#{bin}/print-label --help")
  end
end
