# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class G2o < Formula
  desc "g2o: A General Framework for Graph Optimization"
  homepage "http://openslam.org/g2o.html"
  url "https://github.com/RainerKuemmerle/g2o/archive/20170730_git.tar.gz"
  sha256 "799a7a943de423f7514c6cfdc7ed1c7393a15a73ff88aa07ad3fdd571d777d22"
  head "https://github.com/RainerKuemmerle/g2o.git"

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "suite-sparse" => :recommended
  depends_on "qt" => :optional

  def install
    args = std_cmake_args
    if build.with? "qt"
      args << "-DCMAKE_PREFIX_PATH=/usr/local/opt/qt:#{prefix}"
    end
    # ENV.deparallelize  # if your formula fails when building in parallel
    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test g2o`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
