FROM gcr.io/ecp-e4s/ubuntu20.04-runner-x86_64:2021-01-01

ARG SPACK_REF=develop
ARG LLVM_REF=main
ARG MPICH_REF=main

RUN apt update -y \
 && apt install -y libtool gettext \
 && apt autoremove -y \
 && apt clean

COPY spack.yaml spack.lock e4s.pub f18_assemble_new.patch /

RUN git clone https://github.com/spack/spack /opt/spack \
 && (cd /opt/spack && git checkout ${SPACK_REF} && rm -rf .git) \
 && . /opt/spack/share/spack/setup-env.sh \
 && spack gpg trust e4s.pub \
 && spack mirror add E4S https://cache.e4s.io \
 && spack -e . install --cache-only \
 && spack env activate --sh -d . \
     | sed '/SPACK_ENV/d' \
     | sed '/despacktivate/d' \
     | sed 's/:\/opt\/spack\/bin:/:/g' > /env.sh \
 && echo export F18_FC=gfortran >> /env.sh \
 && cat /env.sh >> /etc/bash.bashrc \
 && spack clean -a \
 && rm -rf /tmp/root \
 && rm -rf /opt/spack

COPY mpich-configure.sh /

RUN . /env.sh \
 && git clone https://github.com/pmodels/mpich.git \
 && cd mpich \
 && git checkout ${MPICH_REF} \
 && git submodule update --init \
 && ./autogen.sh \
 && cp /mpich-configure.sh . \
 && ./mpich-configure.sh \
 && make -j64 \
 && make install \
 && find . -maxdepth 1 -name "*.f18.mod" -exec cp {} /usr/local/mpich/include/. \; \
 && rm -rf /mpich

RUN sed -i 's/wl=""/wl="-Wl,"/' /usr/local/mpich/bin/mpif90

RUN . ./env.sh \
 && echo export LD_LIBRARY_PATH=/usr/local/mpich/lib:${LD_LIBRARY_PATH} >> /etc/bash.bashrc \
 && echo export PATH=/usr/local/mpich/bin:${PATH} >> /etc/bash.bashrc

RUN git clone https://github.com/spack/spack /opt/spack \
 && (cd /opt/spack && rm -rf .git) \
 && echo . /opt/spack/share/spack/setup-env.sh >> /etc/bash.bashrc

COPY /compilers.yaml /root/.spack/linux/
COPY /packages.yaml /root/.spack/

WORKDIR /
