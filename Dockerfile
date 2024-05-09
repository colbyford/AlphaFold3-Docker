## Based on: https://github.com/google-deepmind/alphafold/blob/main/docker/Dockerfile

ARG CUDA=12.2.2
FROM nvidia/cuda:${CUDA}-cudnn8-runtime-ubuntu20.04
ARG CUDA

## Change to bash w/ string substitution
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        cuda-command-line-tools-$(cut -f1,2 -d- <<< ${CUDA//./-}) \
        git \
        hmmer \
        kalign \
        tzdata \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
    && apt-get clean

## HHSuite Compile HHsuite from source.
RUN git clone --branch v3.3.0 https://github.com/soedinglab/hh-suite.git /tmp/hh-suite \
    && mkdir /tmp/hh-suite/build \
    && pushd /tmp/hh-suite/build \
    && cmake -DCMAKE_INSTALL_PREFIX=/opt/hhsuite .. \
    && make -j 4 && make install \
    && ln -s /opt/hhsuite/bin/* /usr/bin \
    && popd \
    && rm -rf /tmp/hh-suite

## Miniconda
RUN wget -q -P /tmp \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm /tmp/Miniconda3-latest-Linux-x86_64.sh

## Install conda packages.
ENV PATH="/opt/conda/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/conda/lib:$LD_LIBRARY_PATH"
RUN conda install -qy conda==24.1.2 pip python=3.11 \
    && conda install -y -c nvidia cuda=${CUDA_VERSION} \
    && conda install -y -c conda-forge openmm=8.0.0 pdbfixer \
    && conda clean --all --force-pkgs-dirs --yes

## Change working directory
WORKDIR /app/alphafold

## Copy repo contents into working directory
COPY . .

## Install PyTorch implementation of Alphafold3
RUN pip install alphafold3

## Install pip packages.
RUN pip3 install --upgrade pip --no-cache-dir \
    && pip3 install -r requirements.txt --no-cache-dir \
    && pip3 install --upgrade --no-cache-dir \
      jax==0.4.26 \
      jaxlib==0.4.26+cuda12.cudnn89 \
      -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# Add SETUID bit to the ldconfig binary so that non-root users can run it.
RUN chmod u+s /sbin/ldconfig.real

# Currently needed to avoid undefined_symbol error.
RUN ln -sf /usr/lib/x86_64-linux-gnu/libffi.so.7 /opt/conda/lib/libffi.so.7

