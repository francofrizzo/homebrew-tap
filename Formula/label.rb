class Label < Formula
  include Language::Python::Virtualenv

  desc "Thermal printer label maker for Bluetooth cat printers"
  homepage "https://github.com/francofrizzo/utilities"
  url "https://github.com/francofrizzo/utilities/archive/refs/tags/label-v0.1.0.tar.gz"
  sha256 "dbddc4ef7dab4488a064570881104bcc2c1e6cb8ad11a26f16dc8d00ee732eca"
  license "MIT"

  depends_on "python@3.13"

  # Only include dependencies that build easily from source
  resource "bleak" do
    url "https://files.pythonhosted.org/packages/45/8a/5acbd4da6a5a301fab56ff6d6e9e6b6945e6e4a2d1d213898c21b1d3a19b/bleak-2.1.1.tar.gz"
    sha256 "4600cc5852f2392ce886547e127623f188e689489c5946d422172adf80635cf9"
  end

  def install
    virtualenv_install_with_resources

    cd "label" do
      # Install catprinter library into virtualenv
      (libexec/Language::Python.site_packages("python3.13")).install "lib/catprinter"

      # Install the script
      (libexec/"bin").install "bin/label"

      # Create wrapper that uses virtualenv python
      (bin/"label").write <<~EOS
        #!/bin/bash
        # Check for required dependencies
        if ! "#{libexec}/bin/python" -c "import PIL, numpy, cv2" 2>/dev/null; then
          echo "Missing dependencies. Install with:" >&2
          echo "  #{libexec}/bin/python -m pip install Pillow numpy opencv-python" >&2
          exit 1
        fi
        exec "#{libexec}/bin/python" "#{libexec}/bin/label" "$@"
      EOS

      chmod 0755, bin/"label"
    end
  end

  def post_install
    # Install remaining dependencies that need wheels
    system libexec/"bin/python", "-m", "pip", "install", "--quiet", "Pillow", "numpy", "opencv-python"
  end

  def caveats
    <<~EOS
      Print a label:
        label "PANKO"
        label "BREAD CRUMBS" --subtext "Japanese Style"
    EOS
  end

  test do
    assert_match "Print labels on thermal printer", shell_output("#{bin}/label --help")
  end
end
