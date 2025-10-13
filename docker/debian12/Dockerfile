# Debian 12 base
FROM launcher.gcr.io/google/debian12:latest

# Install requirements
RUN apt-get update && \
    apt-get install -y --no-install-recommends autoconf automake libtool \
            llvm-14-dev libclang-14-dev libgmp-dev pkg-config git ca-certificates \
            build-essential make libgmp3-dev libyaml-dev llvm bison flex \
            texinfo curl clang cmake libomp-dev

# Setup workdir
WORKDIR /root/tools
RUN git clone --depth 1 git://repo.or.cz/ppcg.git && \
    git clone --depth 1 https://gitlab.inria.fr/crossett/pluto-openscop.git && \
    git clone --depth 1 -b 0.9.5 https://github.com/periscop/openscop

# Install ppcg
WORKDIR /root/tools/ppcg
RUN sh -c "./get_submodules.sh && ./autogen.sh && \
          ./configure --with-clang-prefix=/usr/lib/llvm-14 && \
          make && make install"

# Install pluto
WORKDIR /root/tools/pluto-openscop
RUN curl "https://gitlab.inria.fr/pclauss/apollo/-/raw/contextAnalysis/utils/docker/scripts/pluto_doc_gen_fix.patch?ref_type=heads" > pluto_doc_gen_fix.patch
RUN sh -c "git submodule update --init && patch -p1 < pluto_doc_gen_fix.patch && \
          ./autogen.sh && ./configure --with-clang-prefix=/usr/lib/llvm-14 && \
          make && make install"

# Install openscop
WORKDIR /root/tools/openscop
RUN sh -c "./autogen.sh && ./configure && make && make install"

# Add scripts
ADD scripts /root/scripts

# Clone llvm and kokkos
WORKDIR /root/source
ARG clone_repository_args
ARG kokkos_name=polykokkos llvm_name=llvm-for-polykokkos
RUN /root/scripts/clone_repository.sh --kokkos-name ${kokkos_name} --llvm-name ${llvm_name} \
    ${clone_repository_args}

# Install modified llvm
ARG compile_llvm_args
RUN /root/scripts/compile_llvm.sh --name ${llvm_name} ${compile_llvm_args}
ENV LD_LIBRARY_PATH=/root/source/install/lib/x86_64-unknown-linux-gnu:/usr/local/lib:$LD_LIBRARY_PATH

# Install modified Kokkos
ARG compile_kokkos_args
RUN /root/scripts/compile_kokkos.sh --name ${kokkos_name} \
    --clang-path /root/source/install/bin/clang++ ${compile_kokkos_args}

# Add example file
ADD examples /root/source/examples
