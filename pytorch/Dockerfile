
FROM pytorch/pytorch:2.3.0-cuda12.1-cudnn8-runtime

## Add System Dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
        build-essential \
        git \
        wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
    && apt-get clean

## Change working directory
RUN mkdir -p /app/alphafold/kyegomez
WORKDIR /app/alphafold

## Clone and install the KyeGomez package + requirements
RUN cd kyegomez \
    && git clone https://github.com/kyegomez/AlphaFold3 . \
    && git checkout main \
    && python -m pip install -r requirements.txt \
    && python -m pip install torch git+https://github.com/aqlaboratory/openfold \
    && python -m pip install .

