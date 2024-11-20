from flask import Flask, render_template, request, redirect, url_for, session, flash
import os
import sqlite3
import subprocess



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

