# Build with more contrib modules
# Build only shared libs
class Opencv < Formula
  desc "Open Source Computer Vision Library"
  homepage "https://opencv.org"
  url "https://github.com/opencv/opencv/archive/4.0.1.tar.gz"
  sha256 "7b86a0ee804244e0c407321f895b15e4a7162e9c5c0d2efc85f1cadec4011af4"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "ffmpeg"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "numpy"
  depends_on "openexr"
  depends_on "python"
  depends_on "python@2"
  depends_on "tbb"
  depends_on "vtk" => :recommended
  depends_on "qt" if build.with? "vtk"

  if build.with? "vtk"
    depends_on "qt"
  end 
  
  resource "contrib" do
    url "https://github.com/opencv/opencv_contrib/archive/4.0.1.tar.gz"
    sha256 "0d8acbad4b7074cfaafd906a7419c23629179d5e98894714402090b192ef8237"
  end

  def install
    ENV.cxx11
    ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"

    resource("contrib").stage buildpath/"opencv_contrib"

    # Reset PYTHONPATH, workaround for https://github.com/Homebrew/homebrew-science/pull/4885
    ENV.delete("PYTHONPATH")

    py2_prefix = `python2-config --prefix`.chomp
    py2_lib = "#{py2_prefix}/lib"

    py3_config = `python3-config --configdir`.chomp
    py3_include = `python3 -c "import distutils.sysconfig as s; print(s.get_python_inc())"`.chomp
    py3_version = Language::Python.major_minor_version "python3"

    args = std_cmake_args + %W[
      -DCMAKE_OSX_DEPLOYMENT_TARGET=
      -DBUILD_JPEG=ON
      -DOPENCV_ENABLE_NONFREE=ON
      -DOPENCV_EXTRA_MODULES_PATH=#{buildpath}/opencv_contrib/modules
      -DWITH_EIGEN=ON
      -DWITH_FFMPEG=ON
      -DWITH_OPENEXR=ON
      -DWITH_TBB=ON
      -DBUILD_opencv_python2=ON
      -DBUILD_opencv_python3=ON
      -DPYTHON2_EXECUTABLE=#{which "python"}
      -DPYTHON2_LIBRARY=#{py2_lib}/libpython2.7.dylib
      -DPYTHON2_INCLUDE_DIR=#{py2_prefix}/include/python2.7
      -DPYTHON3_EXECUTABLE=#{which "python3"}
      -DPYTHON3_LIBRARY=#{py3_config}/libpython#{py3_version}.dylib
      -DPYTHON3_INCLUDE_DIR=#{py3_include}
    ]

    if build.with? "vtk"
      args = args + %W[
        -DWITH_VTK=ON
        -DWITH_QT=ON
        -DCMAKE_PREFIX_PATH=#{prefix}/opt/qt
      ]
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
      #include <opencv/cv.h>
      #include <iostream>
      int main() {
        std::cout << CV_VERSION << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test"
    assert_equal `./test`.strip, version.to_s

    ["python2.7", "python3"].each do |python|
      output = shell_output("#{python} -c 'import cv2; print(cv2.__version__)'")
      assert_equal version.to_s, output.chomp
    end 
  end
end
