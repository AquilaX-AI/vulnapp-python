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



