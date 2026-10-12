class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.28"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.28/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "680f6f2313fd6814f6f4a309de92216c65e08f49e246526547df6ba19d27ee4c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.28/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "c80a7bf4feb5a7f2d812e62bf8bfad28424710ab410d2f27f69bb8f13f9351e1"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.28/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "c5431aa0580b2ababa42573b84548903006a74889d2f036e099da2bd4564d360"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.28/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "642bf51f030454657ee108c7ab2e341a9ff301740837a9bfc052dcab0a542e25"
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
