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
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sophus/so2.hpp>
      #include <iostream>
      int main(){
        Sophus::SO2d so2d{1.0, 0.0};
        std::cout << so2d.log() << std::endl;
        return 0;
      }
    EOS
    eigen_include = shell_output("brew --prefix").strip + "/opt/eigen/include/eigen3"
    system ENV.cxx, "test.cpp", "-I#{include}", "-I#{eigen_include}", "-std=c++11", "-o", "test"
    assert_equal %w[0], shell_output("./test").split
  end
end
