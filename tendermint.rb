class Tendermint < Formula
  desc "BFT replicated state machines in any programming language"
  homepage "https://tendermint.com/"
  url "https://github.com/tendermint/tendermint/archive/v0.30.0.tar.gz"
  sha256 "85d07d87b94f4c85e4d5cc015373a14a6c4411e8e20931847c137e8c27fb2e6a"

  bottle do
    cellar :any_skip_relocation
  end

  head do
    url "https://github.com/tendermint/tendermint.git",
      :branch => "develop"
  end

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    tendermintpath = buildpath/"src/github.com/tendermint/tendermint"
    tendermintpath.install buildpath.children
    cd tendermintpath do
      system "make", "get_tools"
      system "make", "get_vendor_deps"
      system "make", "build"
      system "make", "build_abci"
      bin.install "build/tendermint"
      bin.install "abci-cli"
    end
  end

  test do
    tendermint_version_without_hash = shell_output("#{bin}/tendermint version").partition("-").first
    assert_match version.to_s, tendermint_version_without_hash
  end
end
