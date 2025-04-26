class CmakeDocs3 < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.7/cmake-3.31.7.tar.gz"
  sha256 "a6d2eb1ebeb99130dfe63ef5a340c3fdb11431cce3d7ca148524c125924cea68"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake-docs3-3.31.7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ab5e6fe32c5fa05061a52302f69f5b5c49a5c13b7acb28522130cc7da4b571"
    sha256 cellar: :any_skip_relocation, ventura:       "2974482259c1f9fabc02f653adf8ddf4ca80fbabc0f0862a6f8ed95c75f8a48b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edfe2803b7f20feabc34e825a1cce3e710c2bc9ce19da9eb732a9b47e2fdc21d"
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
