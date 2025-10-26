#!/bin/bash
set -e

echo "📦 Creating virtual environment for model download..."

# 创建虚拟环境
python3 -m venv modelscope_env
source modelscope_env/bin/activate

echo "📥 Installing modelscope..."
pip install modelscope

echo "💾 Downloading CosyVoice-300M-SFT model..."
mkdir -p pretrained_models
python -c "
from modelscope import snapshot_download
snapshot_download('iic/CosyVoice-300M-SFT', local_dir='./pretrained_models/CosyVoice-300M-SFT')
"

echo "✅ Model downloaded successfully!"
echo "📁 Files in pretrained_models/CosyVoice-300M-SFT/:"
ls -la pretrained_models/CosyVoice-300M-SFT/

echo "🧹 Cleaning up virtual environment..."
deactivate
rm -rf modelscope_env/

echo "🎉 Ready to build and run Docker container!"