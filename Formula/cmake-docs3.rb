class CmakeDocs3 < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.12/cmake-3.31.12.tar.gz"
  sha256 "5f3fd5a54dfa65602bdbed64f981a72673cc19f2d304cc2955cf0dfa0cfd8272"
  license "BSD-3-Clause"

  livecheck do
    formula "cmake3"
  end

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake-docs3-3.31.12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "192cebee526ba33128b06e00983ae80d090814cebd91c15bbfbdeb6aee1092e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c46304ab9dfcb562164212117b3556470677a97a2a7f40ee883f6f985c4efc1e"
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
