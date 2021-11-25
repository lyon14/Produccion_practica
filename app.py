from flask import Flask
from flask import render_template
from flask import Flask, url_for
import os

import psycopg2



conn = psycopg2.connect(host="localhost", database="practica", user="postgres", password="rosita14")

def practicasActuales():
    cur = conn.cursor()
    comando = "select p.id_practicante,m.nombre_completo,c.nombre_carrera,m.rut,m.email,a.id_practica from usuario as m join practicante as p on p.id_usuario = m.id_usuario join carrera as c on c.id_carrera = p.id_carrera join practica as a on a.id_practicante = p.id_practicante where a.estado_practica = 0"
    cur.execute(comando)
    rows = cur.fetchall()
    return rows


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
    lista = practicasActuales()
    return render_template('verPracticasActuales.html', usuario=user, len = len(lista), lista_practicantes = lista, name=name)

@app.route('/listaDePracticantes')
def listaDePracticantes(name=None):
    
    return render_template('listaDePracticantes.html', usuario=user, name=name)

@app.route('/convocatorias')
def convocatorias(name=None):
    return render_template('convocatorias.html', usuario=user, name=name)

@app.route('/convocatoria')
def convocatoria(name=None):
    return render_template('convocatoria.html', usuario=user, name=name)

if __name__ == '__main__':
    app.run(debug=True)