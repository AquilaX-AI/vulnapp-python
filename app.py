from flask import Flask, render_template, request, redirect, url_for, session, flash
import os
import sqlite3
import subprocess

app = Flask(__name__)
app.secret_key = os.urandom(24)



@app.route('/logout')
def logout():
    session.pop('logged_in', None)
    flash('Logged out successfully', 'success')
    return redirect(url_for('index'))

@app.route('/exec_command', methods=['GET', 'POST'])
def exec_command():
    if request.method == 'POST':
        command = request.form['command']
        result = subprocess.getoutput(command)
        return render_template('exec_command.html', result=result)
    return render_template('exec_command.html')

if __name__ == '__main__':
    app.run(debug=True)