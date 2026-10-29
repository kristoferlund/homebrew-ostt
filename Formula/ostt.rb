class Ostt < Formula
  desc "Open Speech-to-Text recording tool with real-time volume metering and transcription"
  homepage "https://github.com/kristoferlund/ostt"
  version "0.0.33"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.33/ostt-aarch64-apple-darwin.tar.gz"
      sha256 "b95bbaa4fe74c3fbea089b4289f83526117d653f4664aab26ea0f54c8d9ac57e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.33/ostt-x86_64-apple-darwin.tar.gz"
      sha256 "415ed864c944c9f1873190e32bbabba2760343bdddf1bcc6b524cb18983d9e82"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.33/ostt-aarch64-unknown-linux-gnu.tar.gz"
      sha256 "2de6d16aad25b3142cc7096cdd01fc77526227592e59194ac7170d506c0f28ff"
    end
    if Hardware::CPU.intel?
      url "https://github.com/kristoferlund/ostt/releases/download/v0.0.33/ostt-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "8f02d9cd09f75a3d2605bf959523a4f6c1272a6df6530d05c40d77bc31401c36"
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
