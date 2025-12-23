class Agency < Formula
  desc "AI Agent Orchestrator in the terminal"
  homepage "https://github.com/tobias-walle/agency"
  version "1.10.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tobias-walle/agency/releases/download/v1.10.0/agency-aarch64-apple-darwin.tar.xz"
    sha256 "544173018f0fa1bbbd40b6696fa2c741fad8ea704984d4fd0bb32fda960981f8"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tobias-walle/agency/releases/download/v1.10.0/agency-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c847b10bdc80dc875583817b4d4072226f09b0bb833f1b8be9253e1138efcf88"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tobias-walle/agency/releases/download/v1.10.0/agency-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f4b50ce7dad679e86522c55dcf4c1b3566cfa80540c96ca09fe053afe61e1b75"
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
