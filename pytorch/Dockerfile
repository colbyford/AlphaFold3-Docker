
FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime

## Add System Dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        git \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
    && apt-get clean

## Change working directory
RUN mkdir -p /app/alphafold
WORKDIR /app/alphafold

## Get the repo content from GitHub (and install requirements)
RUN git clone https://github.com/kyegomez/AlphaFold3 . \
    && git checkout main \
    && python -m pip install -r requirements.txt \
    && python -m pip install git+https://github.com/aqlaboratory/openfold

## Install the package
RUN python -m pip install .

