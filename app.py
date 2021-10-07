from flask import Flask
from flask import render_template
from flask import Flask, url_for
import os

templateFrontend = os.path.abspath('C:/Users/juan/Desktop/proyecto_practicas/Produccion_practica/frontend')

app = Flask(__name__, template_folder=templateFrontend)


@app.route('/')
def index(name=None):
    return render_template('index.html', title='ucen', name=name)

if __name__ == '__main__':
    app.run(debug=True)