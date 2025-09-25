class Cmake3 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.9/cmake-3.31.9.tar.gz"
  sha256 "5d4fdec04247ca8a8e8f63692f0d0f1e9d6d082a2bdd008dff8ab3ba7215aa83"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(3\.\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake3-3.31.8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "190b245a5dc2be0d970bb7dc6befad944180065fb60792cf9e4b161cdd889984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55ee052edd4e57d41e2c3d7e5202d81809e9f8f2ba5aae95f021306ac57d12ba"
    sha256 cellar: :any_skip_relocation, ventura:       "5044020481da102118be452ea7bb034b2eaea97bb29cdc814318cc8f29aac2b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c5af60eaa7fda403d297e0bc51f278f19c76e13c244da921c745b539ef837c5"
  end

  keg_only "conflicts with core formula"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "openssl@3"
  end

  patch :DATA

  def install
    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
    ]
    if OS.mac?
      args += %w[
        --system-zlib
        --system-bzip2
        --system-curl
      ]
    end

    system "./bootstrap", *args, "--", *std_cmake_args,
      "-DCMake_INSTALL_BASH_COMP_DIR=#{bash_completion}",
      "-DCMake_INSTALL_EMACS_DIR=#{elisp}",
      "-DCMake_BUILD_LTO=ON"

    system "make"
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system bin/"cmake", "."
  end
end

__END__
diff --git a/Source/cmSystemTools.cxx b/Source/cmSystemTools.cxx
index 5ad0439c..161257cf 100644
--- a/Source/cmSystemTools.cxx
+++ b/Source/cmSystemTools.cxx
@@ -2551,7 +2551,7 @@ void cmSystemTools::FindCMakeResources(const char* argv0)
     _NSGetExecutablePath(exe_path, &exe_path_size);
   }
   exe_dir =
-    cmSystemTools::GetFilenamePath(cmSystemTools::GetRealPath(exe_path));
+    cmSystemTools::GetFilenamePath(exe_path);
   if (exe_path != exe_path_local) {
     free(exe_path);
   }
@@ -2572,7 +2572,6 @@ void cmSystemTools::FindCMakeResources(const char* argv0)
   std::string exe;
   if (cmSystemTools::FindProgramPath(argv0, exe, errorMsg)) {
     // remove symlinks
-    exe = cmSystemTools::GetRealPath(exe);
     exe_dir = cmSystemTools::GetFilenamePath(exe);
   } else {
     // ???
