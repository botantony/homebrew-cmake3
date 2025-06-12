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
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake-docs3-3.31.7_1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "454e9cc1953ad1a1a10de3bc3e262060a0187ec0a1e6389cb26ce5c891f0dda8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dbb66afebdd153bfdfab1385de3c59a4da7aeb33b16285a4cc99e1019d4abc4"
    sha256 cellar: :any_skip_relocation, ventura:       "493ff02336f7b51090d9545f88a786d393161ed9d137051beea877c3b02c5585"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44abded304bdcc37dd30e2315e93cfc273e1a4912412aaa1531b78313f0b6e26"
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
