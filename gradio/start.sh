#!/bin/bash
set -e

# 默认模型
MODEL_NAME="${COSYVOICE_MODEL:-CosyVoice-300M-SFT}"
MODEL_DIR="/cosyvoice_src/pretrained_models"
MODEL_PATH="$MODEL_DIR/$MODEL_NAME"

echo "🚀 Using model: $MODEL_NAME"

# 下载模型（如果不存在）
if [ ! -d "$MODEL_PATH" ] || [ ! -f "$MODEL_PATH/.downloaded" ]; then
    echo "📥 Downloading model..."
    python -c "
import os
from modelscope import snapshot_download
os.makedirs('$MODEL_DIR', exist_ok=True)
snapshot_download('iic/$MODEL_NAME', local_dir='$MODEL_PATH')
"
    touch "$MODEL_PATH/.downloaded"
    echo "✅ Model downloaded."
fi

# 启动 WebUI（已 patch 为 0.0.0.0）
echo "🌐 Starting WebUI on port 7860..."
exec python webui.py --port 7860 --model_dir "$MODEL_PATH"