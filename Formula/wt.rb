class Wt < Formula
  desc "Git worktree manager with GitHub PR and CI status integration"
  homepage "https://github.com/francofrizzo/wt"
  url "https://github.com/francofrizzo/wt/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "b04885877c8ff77c75764e2280027113136387f46700de114916fcddb3178115"
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
