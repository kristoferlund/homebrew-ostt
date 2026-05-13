class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.11/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "5f843cc0a00da879f2d565a43d980b81a3a70e6ba5b3c8a2f380ffa9d7e00092"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.11/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "c5036cd577bb3abf8c75d8d811a9cb65bfd4042fb0f7678d6cc7a881c1c15a01"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.11/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "773bdfb7d6b4840e815440271e51323161958fced167830ebff5d0e1e1bd398d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.11/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "cc7ee3094c1593e35953b2e2c7ac1250585a4e3916616fba3e899d28248d6b3e"
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
