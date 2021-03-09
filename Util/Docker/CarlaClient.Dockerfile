FROM quay.io/pypa/manylinux2014_x86_64

RUN yum install -y git \
                   ninja-build \
                   wget \
                   zlib-devel \
                   libtiff-devel \
                   libjpeg-devel
 
COPY llvm.repo /etc/yum.repos.d/llvm.repo

RUN rpm --import http://springdale.princeton.edu/data/springdale/7/x86_64/os/RPM-GPG-KEY-springdale
RUN yum install -y llvm-toolset-8.0
 
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rh/llvm-toolset-8.0/root/usr/lib64/
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/carla-build/carla/Build/libpng-1.6.37-install/lib/

RUN update-alternatives --install /usr/bin/clang++ clang++ /opt/rh/llvm-toolset-8.0/root/usr/bin/clang++ 180
RUN update-alternatives --install /usr/bin/clang clang /opt/rh/llvm-toolset-8.0/root/usr/bin/clang 180
RUN update-alternatives --install /usr/bin/clang++-8 clang++-8 /opt/rh/llvm-toolset-8.0/root/usr/bin/clang++ 180
RUN update-alternatives --install /usr/bin/clang-8 clang-8 /opt/rh/llvm-toolset-8.0/root/usr/bin/clang 180

RUN update-alternatives --install /usr/bin/python3.6 python3.6 /opt/python/cp36-cp36m/bin/python3.6 180
RUN update-alternatives --install /usr/bin/python3.7 python3.7 /opt/python/cp37-cp37m/bin/python3.7 180
RUN update-alternatives --install /usr/bin/python3.8 python3.8 /opt/python/cp38-cp38/bin/python3.8 180
RUN update-alternatives --install /usr/bin/python3.9 python3.9 /opt/python/cp39-cp39/bin/python3.9 180

RUN ln -s /opt/python/cp36-cp36m/include/python3.6m /usr/include/python3.6
RUN ln -s /opt/python/cp37-cp37m/include/python3.7m /usr/include/python3.7
RUN ln -s /opt/python/cp38-cp38m/include/python3.8 /usr/include/python3.8
RUN ln -s /opt/python/cp39-cp39m/include/python3.9 /usr/include/python3.9

# libpng

ENV LIBPNG_VERSION=1.6.37

RUN wget "https://sourceforge.net/projects/libpng/files/libpng16/${LIBPNG_VERSION}/libpng-${LIBPNG_VERSION}.tar.xz" &&\
    tar -xf libpng-${LIBPNG_VERSION}.tar.xz &&\
    pushd libpng-${LIBPNG_VERSION} >/dev/null &&\
    ./configure &&\
    make install &&\
    popd >/dev/null &&\
    rm -Rf libpng-${LIBPNG_VERSION}.tar.xz &&\
    rm -Rf libpng-${LIBPNG_VERSION}
