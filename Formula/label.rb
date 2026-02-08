class Label < Formula
  include Language::Python::Virtualenv

  desc "Thermal printer label maker for Bluetooth cat printers"
  homepage "https://github.com/francofrizzo/utilities"
  url "https://github.com/francofrizzo/utilities/archive/refs/tags/label-v0.1.0.tar.gz"
  sha256 "dbddc4ef7dab4488a064570881104bcc2c1e6cb8ad11a26f16dc8d00ee732eca"
  license "MIT"

  depends_on "python@3.11"

  resource "bleak" do
    url "https://files.pythonhosted.org/packages/fc/a5/47009938c89176d199b6d51e97475a1ca9fc33ae79f21ae41ddb49c4e32e/bleak-0.22.3.tar.gz"
    sha256 "dbddc4ef7dab4488a064570881104bcc2c1e6cb8ad11a26f16dc8d00ee732eca"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/a5/26/0d95c04c868f6bdb0c447e3ee2de5564411845e36a858cfd63766bc7b563/pillow-11.0.0.tar.gz"
    sha256 "dbddc4ef7dab4488a064570881104bcc2c1e6cb8ad11a26f16dc8d00ee732eca"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/65/6e/09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058/numpy-1.26.4.tar.gz"
    sha256 "dbddc4ef7dab4488a064570881104bcc2c1e6cb8ad11a26f16dc8d00ee732eca"
  end

  resource "opencv-python" do
    url "https://files.pythonhosted.org/packages/4a/e7/b70a2d9ab205110d715906fc8ec83fbb00404aeb3a37a0654fdb68e5d87b/opencv-python-4.11.0.86.tar.gz"
    sha256 "dbddc4ef7dab4488a064570881104bcc2c1e6cb8ad11a26f16dc8d00ee732eca"
  end

  def install
    virtualenv_install_with_resources

    # Install label from the label subdirectory
    cd "label" do
      # Copy lib directory to the virtualenv
      (libexec/"lib").install "lib/catprinter"

      # Install the main script
      bin.install "bin/label"

      # Fix the shebang and paths
      rewrite_shebang detected_python_shebang, bin/"label"
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
