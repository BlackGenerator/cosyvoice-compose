# gradio/Dockerfile — CosyVoice Gradio WebUI 服务（多阶段构建）

# 第一阶段：构建基础环境（与 web 服务共享）
FROM ghcr.io/mamba-org/micromamba:1.5.8-bookworm-slim as base

USER root

# 安装构建 + 运行时所需的所有系统依赖
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

# 克隆并安装 CosyVoice
RUN git clone --depth=1 --recursive https://github.com/FunAudioLLM/CosyVoice.git /cosyvoice_src
RUN cp -r /cosyvoice_src/cosyvoice /opt/conda/envs/cosyvoice-cpu/lib/python3.10/site-packages/

# 第二阶段：运行时环境（精简版）
FROM ghcr.io/mamba-org/micromamba:1.5.8-bookworm-slim

USER root

# 安装运行时所需的系统依赖（不包含构建工具）
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        libsndfile1 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 复制构建好的环境
COPY --from=base /opt/conda /opt/conda
COPY --from=base /cosyvoice_src/cosyvoice /opt/conda/envs/cosyvoice-cpu/lib/python3.10/site-packages/cosyvoice

ENV PATH=/opt/conda/envs/cosyvoice-cpu/bin:$PATH

# 复制启动脚本
COPY start.sh /cosyvoice_src/start.sh
RUN chmod +x /cosyvoice_src/start.sh

WORKDIR /cosyvoice_src

EXPOSE 7860

# 启动脚本负责：使用本地模型 + 启动 WebUI
CMD ["./start.sh"]