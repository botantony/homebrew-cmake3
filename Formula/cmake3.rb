class Cmake3 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.7/cmake-3.31.7.tar.gz"
  sha256 "a6d2eb1ebeb99130dfe63ef5a340c3fdb11431cce3d7ca148524c125924cea68"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(3\.\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake3-3.31.7_1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ebac0ab45eed0c9624d114803aa2eba98256917edd5e9c89e60a77346a6988a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "608bcf971d89b64e4ec8e2e274250b9cec89da889ee575a652a6789765f4b573"
    sha256 cellar: :any_skip_relocation, ventura:       "78c59b1c31cd218fb6e2d1dbfa2bf2947f74f4cc16e44c028b91d1a2f623a595"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d5783c64527d35791e20f6860af06efed036d23f0d46fb25bc16e895e88822c"
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
