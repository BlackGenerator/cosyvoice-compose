# gradio/Dockerfile — 使用官方 micromamba 预装镜像
FROM ghcr.io/mamba-org/micromamba:1.5.8-bookworm-slim

# 切换为 root 以安装系统包
USER root

# === 安装系统依赖（音频处理所需）===
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        git-lfs \
        ffmpeg \
        libsndfile1 \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# === 设置 conda 环境路径 ===
ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV PATH=$MAMBA_ROOT_PREFIX/bin:$PATH

# === 复制环境文件并创建 conda 环境 ===
COPY environment-cpu.yml /tmp/environment-cpu.yml
RUN micromamba create -y -f /tmp/environment-cpu.yml -n cosyvoice-cpu && \
    micromamba clean --all --yes

# === 激活环境 ===
ENV PATH=/opt/conda/envs/cosyvoice-cpu/bin:$PATH

# 克隆并初始化子模块（确保 third_party 是最新兼容版）
RUN git clone --depth=1 https://github.com/FunAudioLLM/CosyVoice.git /cosyvoice_src && \
    cd /cosyvoice_src && \
    git submodule update --init --recursive

WORKDIR /cosyvoice_src

# 不再需要降级 huggingface_hub
# environment-cpu.yml 中移除 huggingface-hub==0.19.4

# === 关键：修复 webui.py，强制监听 0.0.0.0 ===
# RUN sed -i "s/demo\.launch(/demo.launch(server_name='0.0.0.0', /" examples/webui.py

# === 复制并启用启动脚本 ===
COPY start.sh /cosyvoice_src/start.sh
RUN chmod +x /cosyvoice_src/start.sh

EXPOSE 7860

# 启动脚本负责：下载模型 + 启动服务
CMD ["./start.sh"]