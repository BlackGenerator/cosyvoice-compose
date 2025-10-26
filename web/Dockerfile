# 第一阶段：构建基础环境
FROM ghcr.io/mamba-org/micromamba:1.5.8-bookworm-slim as base

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git git-lfs ffmpeg libsndfile1 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

ENV MAMBA_ROOT_PREFIX=/opt/conda
ENV PATH=$MAMBA_ROOT_PREFIX/bin:$PATH

COPY environment-cpu.yml /tmp/environment-cpu.yml
RUN micromamba create -y -f /tmp/environment-cpu.yml -n cosyvoice-cpu && \
    micromamba clean --all --yes

RUN git clone --depth=1 --recursive https://github.com/FunAudioLLM/CosyVoice.git /cosyvoice_src
RUN cp -r /cosyvoice_src/cosyvoice /opt/conda/envs/cosyvoice-cpu/lib/python3.10/site-packages/

# 第二阶段：运行时环境
FROM ghcr.io/mamba-org/micromamba:1.5.8-bookworm-slim

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg libsndfile1 ca-certificates && \
    rm -rf /var/lib/apt/lists/*

COPY --from=base /opt/conda /opt/conda
COPY --from=base /cosyvoice_src/cosyvoice /opt/conda/envs/cosyvoice-cpu/lib/python3.10/site-packages/cosyvoice

ENV PATH=/opt/conda/envs/cosyvoice-cpu/bin:$PATH
COPY . /app
WORKDIR /app

EXPOSE 7860
CMD ["python", "app.py"]