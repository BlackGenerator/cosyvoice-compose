# web/Dockerfile
FROM cosyvoice-base:latest

USER root

WORKDIR /cosyvoice_src

# 复制conda环境和CosyVoice模块
COPY --from=0 /opt/conda /opt/conda
COPY --from=0 /cosyvoice_src/cosyvoice /opt/conda/envs/cosyvoice-cpu/lib/python3.10/site-packages/cosyvoice

ENV PATH=/opt/conda/envs/cosyvoice-cpu/bin:$PATH

# 复制Flask应用代码
COPY . /app
WORKDIR /app

EXPOSE 7860

CMD ["python", "app.py"]