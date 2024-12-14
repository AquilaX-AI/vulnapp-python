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

@app.route('/')
def index():
    conn = sqlite3.connect('blog.db')
    c = conn.cursor()
    c.execute('SELECT * FROM posts')
    posts = c.fetchall()
    conn.close()
    return render_template('index.html', posts=posts)

@app.route('/add_post', methods=['GET', 'POST'])
def add_post():
    if request.method == 'POST':
        title = request.form['title']
        content = request.form['content']

        # Hardcoded credentials check (vulnerability)
        if request.form['username'] == ADMIN_USERNAME and request.form['password'] == ADMIN_PASSWORD:
            conn = sqlite3.connect('blog.db')
            c = conn.cursor()
            c.execute("INSERT INTO posts (title, content) VALUES ('" + title + "', '" + content + "')")
            conn.commit()
            conn.close()
            return redirect(url_for('index'))
        else:
            return "Unauthorized: Incorrect username or password."

    return render_template('add_post.html')

@app.route('/view_post/<int:id>')
def view_post(id):
    conn = sqlite3.connect('blog.db')
    c = conn.cursor()
    c.execute('SELECT * FROM posts WHERE id = ?', (id,))
    post = c.fetchone()
    conn.close()
    return render_template('view_post.html', post=post)

