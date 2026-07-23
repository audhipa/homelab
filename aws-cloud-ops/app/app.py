from flask import Flask, jsonify
import os
import socket
from datetime import datetime, timezone

app = Flask(__name__)

APP_VERSION = os.getenv("APP_VERSION", "0.1.0")
ENVIRONMENT = os.getenv("ENVIRONMENT", "lab")

@app.route("/")
def index():
    return jsonify({
        "service": "aws-cloud-ops-demo",
        "message": "Dockerized app running on Ubuntu EC2",
        "version": APP_VERSION,
        "environment": ENVIRONMENT,
        "hostname": socket.gethostname(),
        "timestamp_utc": datetime.now(timezone.utc).isoformat()
    })

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "service": "aws-cloud-ops-demo"
    })

@app.route("/version")
def version():
    return jsonify({
        "version": APP_VERSION
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
