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

  needs :cxx11

  def install
    args = std_cmake_args
    if build.with? "qt"
      args << "-DCMAKE_PREFIX_PATH=#{prefix}/opt/qt"
    end
    # ENV.deparallelize  # if your formula fails when building in parallel
    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <g2o/types/slam2d/vertex_point_xy.h>
      #include <iostream>
      int main(){
        number_t xy[2] = {1.0, 2.5};
        g2o::VertexPointXY v{};
        v.setEstimateDataImpl(xy);
        std::cout << v.estimate() << std::endl;
        return 0;
      }
    EOS
    eigen_include = shell_output("brew --prefix").strip + "/opt/eigen/include/eigen3"
    system ENV.cxx, "test.cpp", "-I#{include}", "-I#{eigen_include}", "-L#{lib}", "-lg2o_types_slam2d", "-lg2o_core", "-std=c++11", "-o", "test"
    assert_equal %w[1 2.5], shell_output("./test").split
  end
end
