class Label < Formula
  desc "Thermal printer label maker for Bluetooth cat printers"
  homepage "https://github.com/francofrizzo/utilities"
  url "https://github.com/francofrizzo/utilities/archive/refs/tags/label-v0.1.0.tar.gz"
  sha256 "dbddc4ef7dab4488a064570881104bcc2c1e6cb8ad11a26f16dc8d00ee732eca"
  license "MIT"

  depends_on "python@3.13"

  def install
    # Install everything from the label subdirectory
    cd "label" do
      libexec.install "bin", "lib", "requirements.txt"

      # Create wrapper script
      (bin/"label").write <<~EOS
        #!/bin/bash
        SCRIPT_DIR="#{libexec}"
        export PYTHONPATH="$SCRIPT_DIR/lib:$PYTHONPATH"
        exec "#{Formula["python@3.13"].opt_bin}/python3.13" "$SCRIPT_DIR/bin/label" "$@"
      EOS

      chmod 0755, bin/"label"
    end
  end

  def caveats
    <<~EOS
      Install Python dependencies:
        #{Formula["python@3.13"].opt_bin}/python3.13 -m pip install -r #{libexec}/requirements.txt

      Then print a label:
        label "PANKO"
        label "BREAD CRUMBS" --subtext "Japanese Style"
    EOS
  end

  test do
    assert_match "Print labels on thermal printer", shell_output("#{bin}/label --help 2>&1", 1)
  end
end
