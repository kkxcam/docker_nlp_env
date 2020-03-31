# docker_nlp_env
nlp专用docker环境
1. 选择适应与服务器的 CUDA、cuDNN、Python、tensorflow-gpu 版本
1.1  使用命令 nvidia-smi 查看 nvidia 版本
nvidia-smi
1.2  查看 nvida 版本对应得 cuda 版本 https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html
1.3  查看 tensorflow_gpu 需要得 CUDA 及 cuDNN环境
1.4 选择的版本如下:
- CUDA 9.0
- cuDNN 7.0
- Python 3.6.x
- tensorflow-gpu  1.5.0 - 1.12.0
