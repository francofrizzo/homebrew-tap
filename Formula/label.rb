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

  def install
    cd "label" do
      virtualenv_install_with_resources
    end
  end

  def post_install
    # Try to install remaining dependencies
    # These often fail to build from source, so install as wheels with pip
    system libexec/"bin/python", "-m", "pip", "install", "--quiet",
           "Pillow", "numpy", "opencv-python"
  rescue
    opoo "Some dependencies failed to install. Run manually:"
    puts "  #{libexec}/bin/python -m pip install Pillow numpy opencv-python"
  end

  def caveats
    missing = []
    begin
      system libexec/"bin/python", "-c", "import PIL"
    rescue
      missing << "Pillow"
    end
    begin
      system libexec/"bin/python", "-c", "import numpy"
    rescue
      missing << "numpy"
    end
    begin
      system libexec/"bin/python", "-c", "import cv2"
    rescue
      missing << "opencv-python"
    end

    if missing.any?
      <<~EOS
        Missing dependencies detected. Install with:
          #{libexec}/bin/python -m pip install #{missing.join(" ")}

        Then print a label:
          label "PANKO"
      EOS
    else
      <<~EOS
        Print a label:
          label "PANKO"
          label "BREAD CRUMBS" --subtext "Japanese Style"
      EOS
    end
  end

  test do
    assert_match "Print labels on thermal printer", shell_output("#{bin}/label --help")
  end
end
