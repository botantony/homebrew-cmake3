class CmakeDocs3 < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.9/cmake-3.31.9.tar.gz"
  sha256 "5d4fdec04247ca8a8e8f63692f0d0f1e9d6d082a2bdd008dff8ab3ba7215aa83"
  license "BSD-3-Clause"

  livecheck do
    formula "cmake3"
  end

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake-docs3-3.31.9"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d35d0b95e2764a747268a02fd80c9cb0d32be246dc5421679d64a746fb57b676"
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
