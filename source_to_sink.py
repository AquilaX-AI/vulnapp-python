from flask import Flask, request
import sqlite3
import os

app = Flask(__name__)
@app.route('/search')
def search():
    # SQL Injection vulnerability
    user_id = request.args.get('id')
    conn = sqlite3.connect('test.db')
    cursor = conn.cursor()
    # SOURCE: request.args.get('id')
    # SINK: cursor.execute()
    cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")
    return cursor.fetchall()

@app.route('/exec')
def exec_cmd():
    # Command Injection vulnerability
    filename = request.args.get('file')
    # SOURCE: request.args.get('file')
    # SINK: os.system()
    os.system(f"cat {filename}")
    return "Done"