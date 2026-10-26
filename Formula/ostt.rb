class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.32"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.32/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "59464e5c3822607b52d6b55ec87f50d3dca769206e6d5e56827529b49465fe81"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.32/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "99b25d6922eb11699954f4b9fdefbcc737461512661256340c11f68a249d2cb2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.32/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "b56769cc6bebe7d03f18c45b5e905aa72eb873a022fd6807abf4d53e9b34cd43"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.32/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "290a59ad2f11b8540b5c0c8be58d48955adb221e7cee8cce56c9dd4177f1b751"
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
