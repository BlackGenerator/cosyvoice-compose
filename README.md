# CosyVoice Compose — 轻量级 CPU 部署方案

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

本项目提供 **纯 CPU 环境下** 部署 [FunAudioLLM/CosyVoice](https://github.com/FunAudioLLM/CosyVoice) 的 Docker Compose 解决方案，适用于阿里云、腾讯云、本地服务器等无 GPU 的场景。

支持两种服务：
- 🎙️ **Gradio WebUI**：官方可视化界面（`webui.py`）
- 🌐 **Flask API**：自定义 RESTful 接口（`app.py`）

所有依赖已优化为 **CPU-only**，构建过程自动使用 **阿里云内网加速源**（APT + PyPI），大幅提升部署速度。

---

## ✨ 特性

- ✅ 无需 GPU，纯 CPU 推理（基于 `onnxruntime` + `modelscope`）
- ✅ 自动使用阿里云 VPC 内网加速（APT & PyPI）
- ✅ 模型缓存持久化，避免重复下载
- ✅ 模块化设计：`gradio` 与 `web` 服务独立
- ✅ 零侵入：不修改官方 CosyVoice 源码

---

## 📁 项目结构

```bash
cosyvoice-compose/
├── docker-compose.yml          # 服务编排
├── gradio/
│   ├── Dockerfile              # Gradio 服务构建文件
│   └── requirements-cpu.txt    # CPU 依赖列表
├── web/
│   ├── Dockerfile              # Flask API 服务构建文件
│   ├── requirements-cpu.txt    # CPU 依赖列表
│   └── app.py                  # 示例 TTS API（需自行实现）
└── README.md
```

> 💡 `app.py` 仅为示例模板，请根据实际需求编写你的 API 逻辑。

---

## 🚀 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/BlackGenerator/cosyvoice-compose.git
cd cosyvoice-compose
```

### 2. 准备 Flask 应用（可选）

如果你需要 API 服务，请编辑 `web/app.py`，实现你的 TTS 接口逻辑。

示例接口：
```python
POST /tts
{ "text": "你好，世界！" }
→ 返回 audio/wav
```

### 3. 启动服务

```bash
# 构建并启动（首次会下载模型，约 1-2GB）
docker-compose up -d

# 查看日志
docker-compose logs -f gradio  # Gradio WebUI
docker-compose logs -f web     # Flask API（如启用）
```

### 4. 访问服务

- **Gradio WebUI**: http://localhost:7870  
- **Flask API**: http://localhost:7860/tts （需实现）

> 默认端口映射：
> - `7870` → Gradio
> - `7860` → Flask

---

## ⚙️ 配置说明

### 模型缓存

模型会自动下载到宿主机的 `~/.cache/modelscope`，并通过 volume 挂载到容器，**重启不丢失**。

### 端口修改

编辑 `docker-compose.yml` 中的 `ports` 字段即可更改。

### 仅启动 Gradio

如只需 WebUI，注释掉 `web` 服务：

```yaml
# docker-compose.yml
services:
  gradio:
    # ...
  # web:
  #   ...
```

---

## 🛠️ 构建优化

- **PyPI 源**: `https://mirrors.aliyun.com/pypi/simple/`（阿里云全球镜像）
- **APT 源**: 自动替换为 `us-west-1-apt.pkg.alinuxcloud.com`（阿里云地域加速）
- **PyTorch**: 显式安装 `+cpu` 版本，避免 CUDA 依赖

---

## 📜 依赖说明

| 组件 | 用途 |
|------|------|
| `modelscope` | 加载 CosyVoice 预训练模型 |
| `onnxruntime` | CPU 推理引擎 |
| `gradio` | 官方 Web 界面 |
| `flask` | 自定义 API 服务 |

所有 GPU 相关包（`torch+cu118` 等）已移除。

---

## 📄 许可证

本项目基于 [MIT License](LICENSE) 开源。

CosyVoice 模型及代码版权归属 [FunAudioLLM](https://github.com/FunAudioLLM/CosyVoice)。

---

## 🙏 致谢

- [FunAudioLLM/CosyVoice](https://github.com/FunAudioLLM/CosyVoice)
- [ModelScope](https://www.modelscope.cn/)
- [阿里云开源镜像站](https://developer.aliyun.com/mirror/)

---

Made with ❤️ for edge & cloud CPU deployment.


