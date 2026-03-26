class Budi < Formula
  desc "AI cost analytics for coding agents — know where your tokens and money go"
  homepage "https://github.com/siropkin/budi"
  version "7.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/siropkin/budi/releases/download/v7.0.0/budi-v7.0.0-aarch64-apple-darwin.tar.gz"
      sha256 "2024b173630f3124f36e3551dc3fe2854a687f84f640d5421844b9f649856ccf"
    else
      url "https://github.com/siropkin/budi/releases/download/v7.0.0/budi-v7.0.0-x86_64-apple-darwin.tar.gz"
      sha256 "5366ddb251b07d82caf4e1cb7d122c967b8fb89f53d8a99f1dac3a60fd1cfe16"
    end
  end

  on_linux do
    url "https://github.com/siropkin/budi/releases/download/v7.0.0/budi-v7.0.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "48c93729df9657a90ec638d61e91c7c1a27a38c3815c0f0fc9ee8ab7f28a887c"
  end

  def install
    bin.install "budi"
    bin.install "budi-daemon"
  end

  def post_install
    system bin/"budi", "init"
  end

  def caveats
    <<~EOS
      budi has been initialized automatically.
      The daemon is running on http://127.0.0.1:7878

      Open the dashboard:
        budi open

      Load full history (first time only):
        budi history
    EOS
  end

  test do
    assert_match "budi", shell_output("#{bin}/budi --help")
  end
end
