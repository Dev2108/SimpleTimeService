import json
import socket
from flask import Flask, request
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def index():
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    ip = request.headers.get('X-Forwarded-For', request.remote_addr)

    # Return the response in JSON format
    return json.dumps({
        'timestamp': timestamp,
        'ip': ip
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
