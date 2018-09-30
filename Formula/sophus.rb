# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Sophus < Formula
  desc "C++ implementation of Lie Groups using Eigen."
  homepage ""
  url "https://github.com/strasdat/Sophus/archive/v1.0.0.tar.gz"
  sha256 "b4c8808344fe429ec026eca7eb921cef27fe9ff8326a48b72c53c4bf0804ad53"
  head "https://github.com/strasdat/Sophus.git"

  depends_on "cmake" => :build
  depends_on "eigen"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test Sophus`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
