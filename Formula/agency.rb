class Agency < Formula
  desc "AI Agent Orchestrator in the terminal"
  homepage "https://github.com/tobias-walle/agency"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tobias-walle/agency/releases/download/v1.0.0/agency-aarch64-apple-darwin.tar.xz"
      sha256 "53c767d995b931597918f968063b0298601202c174cd13f67b0e0215c6022ab2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tobias-walle/agency/releases/download/v1.0.0/agency-x86_64-apple-darwin.tar.xz"
      sha256 "bfa7f05b60aa561f27a049921da968993131998d9a12891df37ba03d137c4b0f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tobias-walle/agency/releases/download/v1.0.0/agency-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7f82083ecba55795b375955f58b12e9654bc42bc0d096347b55fdfdf9bde9b06"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tobias-walle/agency/releases/download/v1.0.0/agency-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6c62746744ec6ae076dc63a7fae90d40abd164ed9281f8e47717e92920579a3e"
    end
  end

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
    bin.install "agency" if OS.mac? && Hardware::CPU.arm?
    bin.install "agency" if OS.mac? && Hardware::CPU.intel?
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
