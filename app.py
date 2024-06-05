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



@app.route('/exec_command', methods=['GET', 'POST'])
def exec_command():
    if request.method == 'POST':
        command = request.form['command']
        result = subprocess.getoutput(command)
        return render_template('exec_command.html', result=result)
    return render_template('exec_command.html')

if __name__ == '__main__':
    app.run(debug=True)
