class Label < Formula
  include Language::Python::Virtualenv

  desc "Thermal printer label maker for Bluetooth cat printers"
  homepage "https://github.com/francofrizzo/utilities"
  url "https://github.com/francofrizzo/utilities/archive/refs/tags/label-v0.1.0.tar.gz"
  sha256 "dbddc4ef7dab4488a064570881104bcc2c1e6cb8ad11a26f16dc8d00ee732eca"
  license "MIT"

  depends_on "python@3.13"

  # Python dependencies
  resource "bleak" do
    url "https://files.pythonhosted.org/packages/45/8a/5acbd4da6a5a301fab56ff6d6e9e6b6945e6e4a2d1d213898c21b1d3a19b/bleak-2.1.1.tar.gz"
    sha256 "4600cc5852f2392ce886547e127623f188e689489c5946d422172adf80635cf9"
  end

  resource "pillow" do
    url "https://files.pythonhosted.org/packages/94/55/7aca2891560188656e4a91ed9adba305e914a4496800da6b5c0a15f09edf/pillow-12.1.0-cp310-cp310-macosx_11_0_arm64.whl"
    sha256 "cad302dc10fac357d3467a74a9561c90609768a6f73a1923b0fd851b6486f8b0"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/65/6e/09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058/numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"
  end

  resource "opencv-python" do
    url "https://files.pythonhosted.org/packages/fc/6f/5a28fef4c4a382be06afe3938c64cc168223016fa520c5abaf37e8862aa5/opencv_python-4.13.0.92-cp37-abi3-macosx_13_0_arm64.whl"
    sha256 "caf60c071ec391ba51ed00a4a920f996d0b64e3e46068aac1f646b5de0326a19"
  end

  def install
    # Install Python dependencies into virtualenv
    virtualenv_install_with_resources

    # Navigate to label subdirectory
    cd "label" do
      # Copy the catprinter library into the virtualenv
      (libexec/Language::Python.site_packages("python3.13")).install "lib/catprinter"

      # Install the main script
      bin.install "bin/label"

      # Rewrite shebang to use virtualenv python
      rewrite_shebang detected_python_shebang, bin/"label"

      # Fix the import path in the script to use the virtualenv
      inreplace bin/"label",
        "sys.path.insert(0, str(SCRIPT_DIR / 'lib'))",
        "sys.path.insert(0, '#{libexec/Language::Python.site_packages("python3.13")}')"
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
