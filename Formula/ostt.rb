class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.26"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.26/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "6be80c336d7f57a6caef324aa49f297a9104ce32d241f09d96d30de85669a066"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.26/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "3de7f665836f420c3e9711e06c5abca5b4954728a6a36dc116fdbd727e6b9423"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.26/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2147f086b003de94349c573621433e7dc0f108c2d684371ceb62e5eac349599f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.26/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "794ebc0694a86691c044aa4ce3e5a63a2a0dceb6c91d421fa2200576bbefe574"
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
