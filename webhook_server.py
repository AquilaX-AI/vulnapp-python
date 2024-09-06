from flask import Flask, request

app = Flask(__name__)

@app.route('/webhook', methods=['POST'])
def webhook():
    # No signature verification - this is insecure!
    
    # Process the webhook payload
    return 'Webhook received!', 200

if __name__ == '__main__':
    app.run(port=5000)