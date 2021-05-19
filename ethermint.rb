# typed: false
# frozen_string_literal: true

# ethermint.rb
class Ethermint < Formula
  desc "Ethereum powered by Tendermint consensus"
  homepage "https://github.com/cosmos/ethermint"

  head do
    url "https://github.com/cosmos/ethermint.git"
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"
    ethermintpath = buildpath/"src/github.com/cosmos/ethermint"
    ethermintpath.install buildpath.children
    cd ethermintpath do
      system "make", "tools"
      system "make", "deps", "build"
      bin.install "build/emintd"
      bin.install "build/emintcli"
    end
  end

  test do
    ethermint_version = shell_output("#{bin}/ethermint version").split("\n").first.partition("  ")[2]
    ethermint_version_without_hash = ethermint_version.partition("-").first
    assert_match version.to_s, ethermint_version_without_hash
  end
end
