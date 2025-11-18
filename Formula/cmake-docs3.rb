class CmakeDocs3 < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.10/cmake-3.31.10.tar.gz"
  sha256 "cf06fadfd6d41fa8e1ade5099e54976d1d844fd1487ab99942341f91b13d3e29"
  license "BSD-3-Clause"

  livecheck do
    formula "cmake3"
  end

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake-docs3-3.31.10"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "42b3a19b628fd4dd64b981607a2890cff7b37a8026a6817ab9deb8bdd795c9b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b937c75a1bb29d2aba22b5cff610a1baccb8c8d6943c50297d8adbb011886b0b"
  end

  keg_only "it conflicts with core formula"

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
