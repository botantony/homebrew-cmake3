class CmakeDocs3 < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.11/cmake-3.31.11.tar.gz"
  sha256 "c0a3b3f2912b2166f522d5010ffb6029d8454ee635f5ad7a3247e0be7f9a15c9"
  license "BSD-3-Clause"

  livecheck do
    formula "cmake3"
  end

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake-docs3-3.31.11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "859f30afb2ae14240b2c8cc7ebcfe9212daeca72fb5e801adfc7569313464fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b06dd87f187a7e457d05f62e19c8f8f98764b9738abc5ad3ef2cbefbc0fc3777"
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
