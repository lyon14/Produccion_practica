from flask import Flask
from flask import render_template
from flask import Flask, url_for
import os

templateFrontend = os.path.abspath('C:/Users/jiyen/Desktop/carpeta de carpetas/Produccion_practica/frontend')
#C:\Users\jiyen\Desktop\carpeta de carpetas\Produccion_practica\frontend
app = Flask(__name__, template_folder=templateFrontend)

user='cordinador'

@app.route('/')
def index(name=None):
    return render_template('index.html', usuario=user, name=name)

@app.route('/empEvalPracticante')
def empEvalPracticante(name=None):
    return render_template('empEvaluarPracticante.html', usuario=user, name=name)

@app.route('/practFinalizarPractica')
def practFinalizarPractica(name=None):
    return render_template('practFinalizarPractica.html', usuario=user, name=name)

@app.route('/solicitudesDePracticante')
def solicitudesDePracticante(name=None):
    return render_template('solicitudesDePracticante.html', usuario=user, name=name)

@app.route('/verPracticasActuales')
def verPracticasActuales(name=None):
    return render_template('verPracticasActuales.html', usuario=user, name=name)

@app.route('/listaDePracticantes')
def listaDePracticantes(name=None):
    return render_template('listaDePracticantes.html', usuario=user, name=name)

if __name__ == '__main__':
    app.run(debug=True)