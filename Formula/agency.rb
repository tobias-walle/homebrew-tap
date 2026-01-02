class Agency < Formula
  desc "AI Agent Orchestrator in the terminal"
  homepage "https://github.com/tobias-walle/agency"
  version "1.16.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tobias-walle/agency/releases/download/v1.16.0/agency-aarch64-apple-darwin.tar.xz"
    sha256 "aa9da61b7b0373330372f5f691503a0ef456c95b78ecf2bc6afb8adfef989806"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tobias-walle/agency/releases/download/v1.16.0/agency-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1c0c144da5690a2193285d7edc5c219fbc518d3f91f86bc449dbec6ca1986318"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tobias-walle/agency/releases/download/v1.16.0/agency-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d0e54e79a1a5c512d06c00e2ff6fd1359ba7314ad15a6edea11f53f9986f8253"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
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
    bin.install "agency" if OS.mac? && Hardware::CPU.arm?
    bin.install "agency" if OS.linux? && Hardware::CPU.arm?
    bin.install "agency" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
