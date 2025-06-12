class CmakeDocs3 < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.8/cmake-3.31.8.tar.gz"
  sha256 "e3cde3ca83dc2d3212105326b8f1b565116be808394384007e7ef1c253af6caa"
  license "BSD-3-Clause"

  livecheck do
    formula "cmake3"
  end

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake-docs3-3.31.8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9fac8539a3f8f4c279b49a3da88f2678e7dff8a6f497b4240df35f47916989c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bcda41fa737103927b45913ad517a14a806f29925d6a56fd2dc74cbc6bf814ed"
    sha256 cellar: :any_skip_relocation, ventura:       "d9ef56145676bbfc334cc1a68f0218c1e3015c2b186c745835133ea03ef83970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ee140324803faadffddd6ac1c045e80554c2aa4989a5c21f35446abe9b311ae"
  end

  keg_only "conflicts with core formula"

  depends_on "cmake3" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *std_cmake_args,
                                                             "-DCMAKE_DOC_DIR=share/doc/cmake",
                                                             "-DCMAKE_MAN_DIR=share/man",
                                                             "-DSPHINX_MAN=ON",
                                                             "-DSPHINX_HTML=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
