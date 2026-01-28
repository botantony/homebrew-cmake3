class Cmake3 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.11/cmake-3.31.11.tar.gz"
  sha256 "c0a3b3f2912b2166f522d5010ffb6029d8454ee635f5ad7a3247e0be7f9a15c9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(3\.\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake3-3.31.11"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "f732e3b2ca608f6823e187cf09cdbbb9fa86e1cb6c187b4c2a970ae80de25aee"
    sha256 cellar: :any_skip_relocation, sequoia:      "98d7aee5270f78d4f5c4ad28178d34a6fd80a26d8843a2d7a6b94bf4dfa30488"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "bfa09ed1ab560e2304336499bd83e12b20b0e6e5ff8aea537bc1c92c72407198"
  end

  keg_only "it conflicts with core formula"

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
