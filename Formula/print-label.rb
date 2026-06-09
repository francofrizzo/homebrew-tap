class PrintLabel < Formula
  include Language::Python::Virtualenv

  desc "Thermal printer label maker for Bluetooth cat printers"
  homepage "https://github.com/francofrizzo/utilities"
  url "https://github.com/francofrizzo/utilities/archive/refs/tags/label-v0.6.0.tar.gz"
  sha256 "70397c14f2e705b2b263a00d400dc646462bacfc2ef8c2ded7b1a2eac01e656a"
  license "MIT"
  revision 1

  depends_on "python@3.13"

  def install
    virtualenv_create(libexec, "python3.13")

    # Install the package itself without dependencies. The runtime
    # dependencies are pulled in post_install, where network access is
    # available: numpy, Pillow and especially opencv-python ship as binary
    # wheels and are impractical to build from source as Homebrew resources.
    system libexec/"bin/pip", "install", "--no-deps", "--no-build-isolation",
           buildpath/"label"

    bin.install_symlink libexec/"bin/print-label"
    bin.install_symlink libexec/"bin/print-image"
  end

  def post_install
    # Mirror src/print_label setup.py install_requires. Installing bleak via
    # pip pulls in its macOS Bluetooth backend (pyobjc-core,
    # pyobjc-framework-CoreBluetooth) automatically.
    system libexec/"bin/pip", "install", "--quiet",
           "bleak>=0.20", "Pillow>=9.0", "numpy<2.0", "opencv-python<5.0"
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
