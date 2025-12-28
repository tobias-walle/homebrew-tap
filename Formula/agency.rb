class Agency < Formula
  desc "AI Agent Orchestrator in the terminal"
  homepage "https://github.com/tobias-walle/agency"
  version "1.12.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tobias-walle/agency/releases/download/v1.12.0/agency-aarch64-apple-darwin.tar.xz"
    sha256 "c8cf0466172ca2c9292a48fe5bfe9d87cf5e3a8bbbb055d020b6e1035f4b726b"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tobias-walle/agency/releases/download/v1.12.0/agency-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7d01145144e96265d24f2d98ddf8f00c8c649455a12a24b9a63cd754c26e3872"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tobias-walle/agency/releases/download/v1.12.0/agency-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0c419304d10d41fc8aeee86019dc7752658ab3fa53df882f44e380ff8945e38c"
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
