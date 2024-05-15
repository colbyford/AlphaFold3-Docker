# AlphaFold3-Docker
Docker image for AlphaFold3 from Google Deepmind and Isomorphic Labs (using an open-source PyTorch implementation).

<h3 align="right">Colby T. Ford, Ph.D.</h3>

## Build Docker Container
```bash
cd pytorch #or nvidia-cuda
docker build -t af3 .
```

## Run Container
```bash
## With GPUs
docker run  --gpus all -it af3 python
```

## Notes
__Beware:__ This is an early work in progress...

This repo includes two Dockerfiles:
- [pytorch](pytorch): This is a simpler image that uses a PyTorch base image.
- [nvidia-cuda](nvidia-cuda): This is based on the official AlphaFold2 Dockerfile from Google Deepmind and uses an NVIDIA CUDA base image.


These images includes models/implementations from:
- KyeGomez: https://github.com/kyegomez/AlphaFold3/
    - Command: `from alphafold3 import ...`
<!-- - LucidRains: https://github.com/lucidrains/alphafold3-pytorch
    - Command: `import alphafold3_pytorch` -->
