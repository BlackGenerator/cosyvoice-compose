# gradio/Dockerfile
FROM cosyvoice-base:latest

USER root

WORKDIR /cosyvoice_src

# 复制并启用启动脚本
COPY start.sh /cosyvoice_src/start.sh
RUN chmod +x /cosyvoice_src/start.sh

EXPOSE 7860

# 启动脚本负责：下载模型 + 启动服务
CMD ["./start.sh"]