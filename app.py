from flask import Flask, render_template, request, redirect, url_for, session, flash
import os
import sqlite3
import subprocess




@app.route('/delete_post/<int:id>', methods=['POST'])
def delete_post(id):
    conn = sqlite3.connect('blog.db')
    c = conn.cursor()
    c.execute('DELETE FROM posts WHERE id = ?', (id,))
    conn.commit()
    conn.close()
    return redirect(url_for('index'))
