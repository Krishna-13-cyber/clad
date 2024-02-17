FROM debian:buster

RUN apt-get update \
  && apt-get -y install build-essential \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/* \
  && wget https://github.com/Kitware/CMake/releases/download/v3.24.1/cmake-3.24.1-Linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /opt/cmake-3.24.1 \
      && /tmp/cmake-install.sh --skip-license --prefix=/opt/cmake-3.24.1 \
      && rm /tmp/cmake-install.sh \
      && ln -s /opt/cmake-3.24.1/bin/* /usr/local/bin
RUN uname -a
RUN apt-get update && apt-get -y install python3
RUN apt-get update && apt install -y wget curl git build-essential && apt clean
RUN git clone https://github.com/llvm/llvm-project.git
RUN cd llvm-project && git checkout release/16.x
RUN mkdir build && cd build
RUN cmake -DLLVM_ENABLE_PROJECTS="clang" -DCMAKE_BUILD_TYPE="DEBUG" -DLLVM_TARGETS_TO_BUILD=host ../llvm-project/llvm
RUN cmake --build . --target clang -j 8 --parallel $(nproc --all)
RUN cd ../..
RUN git clone https://github.com/vgvassilev/clad.git
RUN cd clad && mkdir build && cd build
RUN cmake -DLLVM_DIR=../../llvm-project/build -DCMAKE_BUILD_TYPE=DEBUG ../
RUN make -j8 clad