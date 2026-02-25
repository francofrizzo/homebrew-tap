class Wt < Formula
  desc "Git worktree manager with GitHub PR and CI status integration"
  homepage "https://github.com/francofrizzo/wt"
  url "https://github.com/francofrizzo/wt/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "cff3f07a326c6100b737656829e651ff840e3d709115bcb157ff18b88913e8ee"
  license "MIT"

  depends_on "jq"
  depends_on "gh"

  def install
    bin.install "bin/wt"
    zsh_completion.install "completions/_wt"
    (share/"wt").install "functions/wt.zsh"
  end

  def caveats
    <<~EOS
      To enable the cd-into-worktree shell wrapper and completions,
      add this to your ~/.zshrc:

        source "$(brew --prefix)/share/wt/wt.zsh"

      Then configure your first repo:

        wt init myproject --bare ~/code/myproject.git
    EOS
  end
end
