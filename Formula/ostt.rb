class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.30"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.30/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "a674ce19f9873bc15232b5a1738364cd6c87e1ce422f68d81342614f75c437fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.30/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "3c5f6964770e368a1d1013e5b2b8c7272d74c32dbc99b05b25b5b10a0806bc2d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.30/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "ef338717859e38e2c48e953d32f0edb8b3fdfdfb9eead7af14a75f96b4234b71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.30/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "33c96e017a8ad87faeb7cd4bde9d80841ec614cf4de5601814fd8d0131a4a891"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "ostt"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "ostt"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "ostt"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "ostt"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
