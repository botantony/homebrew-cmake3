Homebrew tap that allows you to install CMake 3.

## Installation
```
brew install botantony/cmake3/cmake3
```
or
```
brew tap botantony/cmake
brew install cmake3
```

After the formula is installed, binaries and other files are not symlinked to your `$PATH` in order to avoid conflict with the `cmake` formula from the core repository. If you want to use only CMake 3, you can add binaries to `$PATH` by adding this line to your shell config:
```bash
export PATH="$(brew --prefix cmake3)/bin:${PATH}"
```

However, if you plan to use CMake 3 and CMake 4 together, consider adding aliases to the binaries with a `3` suffix:
```bash
alias ccmake3="$(brew --prefix cmake3)/bin/ccmake"
alias cmake3="$(brew --prefix cmake3)/bin/cmake"
alias cpack3="$(brew --prefix cmake3)/bin/cpack3"
alias ctest3="$(brew --prefix cmake3)/bin/ctest3"
```

Note that you can't create a symlink to `$(brew --prefix cmake3)/bin/cmake`, as CMake will complain about "missing libraries".
