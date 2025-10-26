# base/Dockerfile
FROM ghcr.io/mamba-org/micromamba:1.5.8-bookworm-slim

USER root

# 安装系统依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        git-lfs \
        ffmpeg \
        libsndfile1 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 设置conda环境路径
ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV PATH=$MAMBA_ROOT_PREFIX/bin:$PATH

# 复制环境文件并创建conda环境
COPY environment-cpu.yml /tmp/environment-cpu.yml
RUN micromamba create -y -f /tmp/environment-cpu.yml -n cosyvoice-cpu && \
    micromamba clean --all --yes

# 激活环境
ENV PATH=/opt/conda/envs/cosyvoice-cpu/bin:$PATH

# 克隆CosyVoice源码
RUN git clone --depth=1 https://github.com/FunAudioLLM/CosyVoice.git /cosyvoice_src && \
    cd /cosyvoice_src && \
    git submodule update --init --recursive

WORKDIR /cosyvoice_src