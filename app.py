from flask import Flask, render_template, request, redirect, url_for, session, flash
import os
import sqlite3
import subprocess

app = Flask(__name__)
app.secret_key = os.urandom(24)

# Hardcoded credentials (for demonstration purposes only)
ADMIN_USERNAME = 'admin'
ADMIN_PASSWORD = '0zu9r2idf9c0tfcc4w26l66ij7visb8q'

# Initialize the database
conn = sqlite3.connect('blog.db')
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS posts 
             (id INTEGER PRIMARY KEY, title TEXT, content TEXT)''')
conn.commit()
conn.close()


def exec_command():
    if request.method == 'POST':
        command = request.form['command']
        result = subprocess.getoutput(command)
        return render_template('exec_command.html', result=result)
    return render_template('exec_command.html')

if __name__ == '__main__':
    app.run(debug=True)