# web/Dockerfile — 复用 gradio 的 conda 环境

# 从 gradio 镜像复制 conda 环境
FROM ghcr.io/mamba-org/micromamba:1.5.8-bookworm-slim as gradio-base

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

ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV PATH=$MAMBA_ROOT_PREFIX/bin:$PATH

# 复制环境文件并创建 conda 环境
COPY environment-cpu.yml /tmp/environment-cpu.yml
RUN micromamba create -y -f /tmp/environment-cpu.yml -n cosyvoice-cpu && \
    micromamba clean --all --yes

# 克隆 CosyVoice 源码
RUN git clone --depth=1 --recursive https://github.com/FunAudioLLM/CosyVoice.git /cosyvoice_src

# 安装 CosyVoice 模块
RUN cp -r /cosyvoice_src/cosyvoice /opt/conda/envs/cosyvoice-cpu/lib/python3.10/site-packages/

# 第二阶段：仅复制环境，不包含 git 源码
FROM ghcr.io/mamba-org/micromamba:1.5.8-bookworm-slim

USER root

# 复制系统依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        libsndfile1 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 复制 conda 环境和 CosyVoice 模块
COPY --from=gradio-base /opt/conda /opt/conda
COPY --from=gradio-base /cosyvoice_src/cosyvoice /opt/conda/envs/cosyvoice-cpu/lib/python3.10/site-packages/cosyvoice

ENV PATH=/opt/conda/envs/cosyvoice-cpu/bin:$PATH

# 复制 Flask 应用代码
COPY . /app
WORKDIR /app

EXPOSE 7860

CMD ["python", "app.py"]