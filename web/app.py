# web/app.py
import os
import torch
import soundfile as sf
from flask import Flask, render_template, request, jsonify, send_file
from cosyvoice.cli.cosyvoice import CosyVoice
import tempfile

app = Flask(__name__)
app.config['STATIC_FOLDER'] = '/app/static'

# 确保输出目录存在
os.makedirs(app.config['STATIC_FOLDER'], exist_ok=True)

print("🔄 正在加载 CosyVoice 模型（CPU）...")
model = CosyVoice('CosyVoice-300M')
print("✅ 模型加载完成！")

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/tts', methods=['POST'])
def tts():
    try:
        data = request.json
        text = data.get('text', '').strip()
        voice = data.get('voice', '中文女')
        if not text:
            return jsonify({"error": "文本不能为空"}), 400

        result = model.inference_sft(text, voice)
        audio = result['tts_speech'].numpy().flatten()

        # 保存为静态文件（供前端播放）
        output_path = os.path.join(app.config['STATIC_FOLDER'], 'output.wav')
        sf.write(output_path, audio, 22050)

        return jsonify({"audio_url": "/static/output.wav"})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/voices')
def voices():
    return jsonify([
        "中文女", "中文男", "英文女", "英文男",
        "日语男", "韩语女", "粤语女"
    ])

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=7860)