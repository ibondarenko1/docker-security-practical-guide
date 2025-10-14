from flask import Flask, request, jsonify
import json
import time
import os

app = Flask(__name__)

# Simulate model loading
MODEL_NAME = os.getenv('MODEL_NAME', 'sample-model')
print(f"Loading model: {MODEL_NAME}")

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy", "model": MODEL_NAME})

@app.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.get_json()
        text = data.get('text', '')
        
        # Simulate inference
        time.sleep(0.1)
        
        # Basic validation to prevent resource exhaustion
        if len(text) > 10000:
            return jsonify({"error": "Input too large"}), 400
        
        result = {
            "prediction": "positive" if len(text) % 2 == 0 else "negative",
            "confidence": 0.85,
            "length": len(text)
        }
        
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/metrics', methods=['GET'])
def metrics():
    # Return simple metrics
    return jsonify({
        "requests": 1000,
        "avg_latency": 0.1,
        "memory_mb": 256
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
