class Label < Formula
  include Language::Python::Virtualenv

  desc "Thermal printer label maker for Bluetooth cat printers"
  homepage "https://github.com/francofrizzo/utilities"
  url "https://github.com/francofrizzo/utilities/archive/refs/tags/label-v0.1.1.tar.gz"
  sha256 "dbc22c76cf8f9fceccea69ca58632a6e55a24c4cf9434c3b85c6514e2fd31dd0"
  license "MIT"

  depends_on "python@3.13"

  resource "bleak" do
    url "https://files.pythonhosted.org/packages/45/8a/5acbd4da6a5a301fab56ff6d6e9e6b6945e6e4a2d1d213898c21b1d3a19b/bleak-2.1.1.tar.gz"
    sha256 "4600cc5852f2392ce886547e127623f188e689489c5946d422172adf80635cf9"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/a5/26/0d95c04c868f6bdb0c447e3ee2de5564411845e36a858cfd63766bc7b563/pillow-11.0.0.tar.gz"
    sha256 "72bacbaf24ac003fea9bff9837d1eedb6088758d41e100c1552930151f677739"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/65/6e/09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058/numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"
  end

  resource "opencv-python" do
    url "https://files.pythonhosted.org/packages/4a/e7/b70a2d9ab205110d715906fc8ec83fbb00404aeb3a37a0654fdb68e5d87b/opencv-python-4.11.0.86.tar.gz"
    sha256 "4d8a7e45bf48302e838510d621dbfc53c1e2ce0e3ab2709afdaa70e6cd82e93c"
  end

  def install
    # Change to label subdirectory where setup.py is
    cd "label" do
      virtualenv_install_with_resources
    end
  end

  def caveats
    <<~EOS
      Print a label:
        label "PANKO"
        label "BREAD CRUMBS" --subtext "Japanese Style"

      See all options:
        label --help
    EOS
  end

  test do
    assert_match "Print labels on thermal printer", shell_output("#{bin}/label --help")
  end
end
