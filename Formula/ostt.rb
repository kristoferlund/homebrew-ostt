class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.9/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "95a407cf5aa01daf88ec12a96941cb1f2afe1f631ae8a3abbe2fbbdb46cf8416"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.9/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "cffb204aacba311ffa1f1b4578f50f6db67eb546f06a30073b14f8fc2d3d28c5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.9/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "30ccc7405c89414abbb259f974dcf5a1438a33b039a9de0d6436031b6bb0f231"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.9/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "a3aa9ca04c4908908920816efaa77379aac9236b67d4a89918da361380448833"
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
