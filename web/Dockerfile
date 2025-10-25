# web/Dockerfile
# 用于部署自定义 Flask API 服务（调用 CosyVoice，纯 CPU）

FROM python:3.10-slim

WORKDIR /app

# === 安全处理 APT 源（兼容无 sources.list）===
RUN set -eux; \
    CODENAME="$(grep -oP 'VERSION_CODENAME=\K\w+' /etc/os-release || echo 'bookworm')"; \
    if [ ! -s /etc/apt/sources.list ]; then \
        echo "deb http://deb.debian.org/debian $CODENAME main" > /etc/apt/sources.list; \
        echo "deb http://deb.debian.org/debian-security $CODENAME-security main" >> /etc/apt/sources.list; \
        echo "deb http://deb.debian.org/debian $CODENAME-updates main" >> /etc/apt/sources.list; \
    fi; \
    sed -i "s|http://deb\.debian\.org|http://us-west-1-apt.pkg.alinuxcloud.com|g" /etc/apt/sources.list; \
    sed -i "s|http://security\.debian\.org|http://us-west-1-apt.pkg.alinuxcloud.com|g" /etc/apt/sources.list

# 安装系统依赖（走阿里云 VPC 内网）
RUN apt-get update && \
    apt-get install -y --no-install-recommends git ffmpeg libsndfile1 && \
    rm -rf /var/lib/apt/lists/*

# === 使用正确的阿里云 PyPI 镜像 ===
ENV PIP_INDEX_URL=https://mirrors.aliyun.com/pypi/simple/
ENV PIP_TRUSTED_HOST=mirrors.aliyun.com

# 克隆官方 CosyVoice 仓库（用于获取 cosyvoice/ 模块）
RUN git clone https://github.com/FunAudioLLM/CosyVoice.git /cosyvoice_src

# 安装 CPU 兼容的 Python 依赖（含 Flask）
COPY requirements-cpu.txt .
RUN pip install --no-cache-dir -r requirements-cpu.txt

# === 安装 PyTorch CPU 版本（必须走官方源）===
RUN unset PIP_INDEX_URL PIP_TRUSTED_HOST && \
    pip install torch==2.3.1+cpu torchaudio==2.3.1+cpu -f https://download.pytorch.org/whl/cpu/torch_stable.html

# === 使 cosyvoice 模块可导入 ===
RUN cp -r /cosyvoice_src/cosyvoice /usr/local/lib/python3.10/site-packages/

# 清理源码（可选）
RUN rm -rf /cosyvoice_src

# 复制你的 Flask 应用代码（app.py 等）
COPY . .

EXPOSE 7860

CMD ["python", "app.py"]