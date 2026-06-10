class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.25"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.25/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "77038457df197da909332ab147361e9524c5a0fb26a2ddab8f5e62dae262c16e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.25/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "c8c784251cc0ba77602d8722896d5f2bf5bc5a26569b32ff6a504601d46cd0cd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.25/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "0c309f44aebb4888fdf98b1dc6953cd5e44f509eb7d02755516d64b92196244a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.25/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "bc4e945f87328c48fe952abdd243af363d8f9bf3a3f1b55d2ea7b0e236a7425a"
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
