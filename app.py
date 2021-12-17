import re
from flask import Flask
from flask import render_template
from flask import Flask, url_for
from flask import Flask, session
from flask import request
from flask import jsonify
from flask import redirect
import json

import os
from flask.json import dump

import psycopg2



conn = psycopg2.connect(host="localhost", database="practica", user="postgres", password="rosita14")

def practicasActuales():
    cur = conn.cursor()
    comando = "select p.id_practicante,m.nombre_completo,c.nombre_carrera,m.rut,m.email,a.id_practica from usuario as m join practicante as p on p.id_usuario = m.id_usuario join carrera as c on c.id_carrera = p.id_carrera join practica as a on a.id_practicante = p.id_practicante where a.estado_practica = 0"
    cur.execute(comando)
    rows = cur.fetchall()
    return rows

def buscarporEmail(email):
    cur = conn.cursor()
    comando = "select * from usuario where email = '"+email+"'"
    cur.execute(comando)
    rows = cur.fetchall()
    conn.commit()
    return rows

def ultimoId(tabla):
    cur = conn.cursor()
    comando = "select max(id_"+tabla+") from "+tabla
    cur.execute(comando)
    rows = cur.fetchall()
    conn.commit()
    return rows

def insertarSolicitud(new_id_solicitud, id_usuario,dato_json):
    cur = conn.cursor()
    comando = "insert into solicitud (id_solicitud, id_practicante, estado_solicitud, formulario) values ("+str(new_id_solicitud)+", "+str(id_usuario)+", 0, '"+dato_json+"')"
    cur.execute(comando)
    conn.commit()
    return "ok"

def solicitudesPracticantes():
    cur = conn.cursor()
    comando = "select s.id_solicitud,s.id_practicante,s.estado_solicitud,s.formulario,m.nombre_completo,m.rut,m.email,c.nombre_carrera from usuario as m join practicante as p on p.id_usuario = m.id_usuario join carrera as c on c.id_carrera = p.id_carrera join solicitud as s on s.id_practicante = p.id_practicante ORDER BY id_solicitud DESC"
    cur.execute(comando)
    rows = cur.fetchall()
    return rows

def TraerFormulario(id_solicitud):
    cur = conn.cursor()
    comando = "select * FROM solicitud WHERE id_solicitud = '"+id_solicitud+"'"
    cur.execute(comando)
    rows = cur.fetchall()
    conn.commit()
    return rows

def actualizarSolPracticante(id_solicitud, estado):
    cur = conn.cursor()
    comando = "update solicitud set estado_solicitud = '"+estado+"' where id_solicitud = '"+id_solicitud+"'"
    cur.execute(comando)
    conn.commit()
    return "ok"

templateFrontend = os.path.abspath('C:/Users/jiyen/Desktop/carpeta de carpetas/Produccion_practica/frontend')
#C:\Users\jiyen\Desktop\carpeta de carpetas\Produccion_practica\frontend
app = Flask(__name__, template_folder=templateFrontend)

app.secret_key = "caircocoders-ednalan"
user=''

@app.route('/')
def index(name=None):
    return render_template('index.html', usuario=user,name=name)

@app.route('/empEvalPracticante')
def empEvalPracticante(name=None):
    return render_template('empEvaluarPracticante.html', usuario=user, name=name)

@app.route('/practFinalizarPractica')
def practFinalizarPractica(name=None):
    return render_template('practFinalizarPractica.html', usuario=user, name=name)

@app.route('/solicitudesDePracticante')
def solicitudesDePracticante(name=None):
    lista = solicitudesPracticantes()
    return render_template('solicitudesDePracticante.html', usuario=user, len = len(lista), lista_practicantes = lista, name=name)

@app.route('/verPracticasActuales')
def verPracticasActuales(name=None):
    lista = solicitudesPracticantes()
    return render_template('verPracticasActuales.html', usuario=user, len = len(lista), lista_solicitudes = lista, name=name)

@app.route('/listaDePracticantes')
def listaDePracticantes(name=None):
    return render_template('listaDePracticantes.html', usuario=user, name=name)

@app.route('/convocatorias')
def convocatorias(name=None):
    return render_template('convocatorias.html', usuario=user, name=name)

@app.route('/convocatoria')
def convocatoria(name=None):
    return render_template('convocatoria.html', usuario=user, name=name)

@app.route('/login',methods=["POST","GET"])
def login():
    global user

    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        print(email)
        print(password)
        listarParametros = buscarporEmail(email)
        print(listarParametros)
        
        id_usuario = listarParametros[0][0]
        tipo_usuario=listarParametros[0][1]
        nombre = listarParametros[0][2]
        rut = listarParametros[0][3]
        bd_email=listarParametros[0][4]
        telefono = listarParametros[0][5]
        bd_password=listarParametros[0][6]
        
        if email == bd_email:
            if  password == bd_password:
                user = str(tipo_usuario)
                session['logged_in'] = True
                session['id_usuario'] = id_usuario
                session['nombre'] = nombre
                session['rut'] = rut
                session['email'] = email
                session['telefono'] = telefono
                msg = 'success'
            else:
                msg = 'No-data'
        else:
            msg = 'No-data'
    
    return jsonify(msg)

@app.route('/logout')
def logout():
    global user
    user = ''
    session.clear()
    return redirect('/')


@app.route('/solicitarPractica',methods=["POST","GET"])
def solicitarPractica():
    if request.method=="POST":
        carrera = request.form['carrera']
        tipo_practica = request.form['tipo_practica']
        nombre_Empresa = request.form['nombre_Empresa']
        destinatario = request.form['destinatario']
        cargo_destinatario = request.form['cargo_destinatario']
        telefono_destinatario = request.form['telefono_destinatario']
        email_destinatario = request.form['email_destinatario']
        id_usuario = request.form['id_usuario']
        nombre_alumno = request.form['nombre_alumno']
        telefono_alumno = request.form['telefono_alumno']
        email_alumno = request.form['email_alumno']
        rut_alumno = request.form['rut_alumno']

        dato_json = {
                    'carrera': carrera,
                    'tipo_practica': tipo_practica,
                    'nombre_Empresa': nombre_Empresa,
                    'destinatario': destinatario,
                    'cargo_destinatario': cargo_destinatario,
                    'telefono_destinatario': telefono_destinatario,
                    'email_destinatario': email_destinatario,
                    'id_usuario': id_usuario,
                    'nombre_alumno': nombre_alumno,
                    'telefono_alumno': telefono_alumno,
                    'email_alumno': email_alumno,
                    'rut_alumno': rut_alumno
                    }
        
        dato_json = json.dumps(dato_json)

        last_id = ultimoId('solicitud')
        new_id_solicitud = int(last_id[0][0]+1)

        id_usuario = int(id_usuario)
        insertarSolicitud(new_id_solicitud, id_usuario,dato_json)
        msg = 'success'
        
    else:
        msg = 'No-data'

    return jsonify(msg)

@app.route('/generarEstadoSolPracticante',methods=["POST","GET"])
def generarEstadoSolPracticante():
    if request.method=="POST":
        id_solicitud = request.form['id_solicitud']
        listaSolicitudes = TraerFormulario(id_solicitud)
        print(listaSolicitudes)
        
        msg = listaSolicitudes

    return jsonify(msg)

@app.route('/actualizarEstadoSolPracticante',methods=["POST","GET"])
def aprobarSolPracticante():
    if request.method=="POST":

        id_solicitud = request.form['id_solicitud']
        estado = request.form['estado']

        actualizarSolPracticante(id_solicitud, estado)

        msg = 'succes'

    return jsonify(msg)

if __name__ == '__main__':
    app.run(debug=True)