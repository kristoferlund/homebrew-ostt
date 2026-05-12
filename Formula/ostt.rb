class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.10/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "d97b29d95fc1a12049e28b9e87324b9651f3aac1eb58da857963f05ecf6ff9ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.10/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "9403d795cbdfc93121b57bc3893a06becdf69538110b8fe06c7ab14e749ff174"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.10/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "dbc21d9a3ccf3a9e9ef105b0a33c54e1a8577c9448afcc70003ddb81e0590fec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.10/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ccdaa5a5b11000a346db9eea93fd1b432f3400fbaa12f2a1d842563b77437410"
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
