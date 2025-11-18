class Cmake3 < Formula
  desc "Cross-platform make"
  homepage "https://www.cmake.org"
  url "https://github.com/Kitware/CMake/releases/download/v3.31.10/cmake-3.31.10.tar.gz"
  sha256 "cf06fadfd6d41fa8e1ade5099e54976d1d844fd1487ab99942341f91b13d3e29"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(3\.\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/botantony/homebrew-cmake3/releases/download/cmake3-3.31.9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "6a77d775839bf38c0e189246ac7b191386ff495e808de96611dbdcc72fa05001"
    sha256 cellar: :any_skip_relocation, ventura:      "02dde7c707959a532be51e6532d1ff11dbae83bea949d61cca646e0ab1442a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3cad1a1d6f740defedd74a9e670f81e385ced9c9710492f50c737adefc68957e"
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
