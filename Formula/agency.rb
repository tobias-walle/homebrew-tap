class Agency < Formula
  desc "AI Agent Orchestrator in the terminal"
  homepage "https://github.com/tobias-walle/agency"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tobias-walle/agency/releases/download/v1.2.0/agency-aarch64-apple-darwin.tar.xz"
      sha256 "cc309f0de544be50cb4d6fef757e36058e17bd13600227210271167e157e914b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tobias-walle/agency/releases/download/v1.2.0/agency-x86_64-apple-darwin.tar.xz"
      sha256 "02d6aa1538058513ca5a480a849ff4a2cf971d5cadbae7079cd71978e9522232"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tobias-walle/agency/releases/download/v1.2.0/agency-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "541bfcf065000098f0cf9885662d0d8468e57b768e4e6598f448957e70ffc785"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tobias-walle/agency/releases/download/v1.2.0/agency-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6edd7e13bc6aaf9716e8cbb4a3c3feaec909f81433a8f53940704a3933dfbe72"
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
