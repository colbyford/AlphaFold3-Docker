## Based on: https://github.com/google-deepmind/alphafold/blob/main/docker/Dockerfile
ARG CUDA=12.2.2
FROM nvidia/cuda:${CUDA}-cudnn8-runtime-ubuntu20.04
ARG CUDA

## Change to bash w/ string substitution
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

## Add System Dependencies
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

## Install Miniconda
RUN wget -q -P /tmp \
  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && bash /tmp/Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda \
    && rm /tmp/Miniconda3-latest-Linux-x86_64.sh

## Install conda packages.
ENV PATH="/opt/conda/bin:$PATH"
ENV LD_LIBRARY_PATH="/opt/conda/lib:$LD_LIBRARY_PATH"
RUN conda install -qy conda==24.1.2 pip python=3.11 \
    && conda install -y -c nvidia cuda=${CUDA_VERSION} \
    && conda install -y -c conda-forge openmm=8.0.0 pdbfixer ncurses \
    && conda clean --all --force-pkgs-dirs --yes

## Change working directory
RUN mkdir -p /app/alphafold
WORKDIR /app/alphafold

## Hack: Avoid undefined_symbol error.
RUN ln -sf /usr/lib/x86_64-linux-gnu/libffi.so.7 /opt/conda/lib/libffi.so.7

## Clone and install the KyeGomez package + requirements
RUN git clone https://github.com/kyegomez/AlphaFold3 . \
    && git checkout main \
    && python -m pip install -r requirements.txt \
    && python -m pip install git+https://github.com/aqlaboratory/openfold \
    && python -m pip install .

## Add SETUID bit to the ldconfig binary so that non-root users can run it.
RUN chmod u+s /sbin/ldconfig.real

## Hack: Avoid undefined_symbol error.
RUN ln -sf /usr/lib/x86_64-linux-gnu/libffi.so.7 /opt/conda/lib/libffi.so.7

