# AlphaFold3-Docker
Docker image for AlphaFold3 from Google Deepmind and Isomorphic Labs (using an open-source PyTorch implementation)

<h3 align="right">Colby T. Ford, Ph.D.</h3>

## Notes
Beware: This is an early work in progress.

This repo includes two Dockerfiles:
- [nvidia-cuda](nvidia-cuda): This is based on the official AlphaFold2 Dockerfile from Google Deepmind and uses the NVIDIA CUDA base image.
- [pytorch](pytorch): This is a simpler image that uses the PyTorch base image.

These images includes models/implementations from:
- KyeGomez: https://github.com/kyegomez/AlphaFold3/
<!-- - LucidRains: https://github.com/lucidrains/alphafold3-pytorch -->


## Build Docker Container
```bash
cd pytorch #or nvidia-cuda
docker build -t af3 .
```
<<<<<<< Updated upstream
=======

## Run Container
```bash
## With GPUs
docker run  --gpus all -it af3
```
>>>>>>> Stashed changes
