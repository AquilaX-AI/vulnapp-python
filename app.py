from flask import Flask, render_template, request, redirect, url_for, session, flash
import os
import sqlite3
import subprocess



@app.route('/')
def index():
    conn = sqlite3.connect('blog.db')
    c = conn.cursor()
    c.execute('SELECT * FROM posts')
    posts = c.fetchall()
    conn.close()
    return render_template('index.html', posts=posts)



    return render_template('add_post.html')

@app.route('/view_post/<int:id>')
def view_post(id):
    conn = sqlite3.connect('blog.db')
    c = conn.cursor()
    c.execute('SELECT * FROM posts WHERE id = ?', (id,))
    post = c.fetchone()
    conn.close()
    return render_template('view_post.html', post=post)

@app.route('/delete_post/<int:id>', methods=['POST'])
def delete_post(id):
    conn = sqlite3.connect('blog.db')
    c = conn.cursor()
    c.execute('DELETE FROM posts WHERE id = ?', (id,))
    conn.commit()
    conn.close()
    return redirect(url_for('index'))
