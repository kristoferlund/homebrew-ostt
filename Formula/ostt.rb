class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.2/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "fffad543354f639024a17c62a0bfcb4a69f5fb2e81fd7a0c402ad77d465bfe67"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.2/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "36c76139745894832fde1eb8b1b182f4ad65c515361f3b2cca9b6ef09d325f92"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.2/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ce2067031e101aa59f7936d28df95f8fd3a00718264ecaa81cea430ab1954f23"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.2/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "3347a5b2c3c3cf0f62d142a1c13bda8a39a64658cdf5337b146456f4f80ba58d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "ostt" if OS.mac? && Hardware::CPU.arm?
    bin.install "ostt" if OS.mac? && Hardware::CPU.intel?
    bin.install "ostt" if OS.linux? && Hardware::CPU.arm?
    bin.install "ostt" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
