import hashlib

from flask import Flask, request, jsonify

from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.ext.automap import automap_base

from models import usuario_model, historial_model


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://damian:damian@localhost:5432/tesisdb'
db = SQLAlchemy(app)

#usuario = db.Table('usuario_usuario', db.metadata, autoload=True, autoload_with=db.engine)

Base = automap_base()
Base.prepare(db.engine, reflect=True)
Usuario = Base.classes.usuario_usuario

Historial = Base.classes.historial_historial


def encode(password):
    return hashlib.md5(password.encode()).hexdigest()


@app.route('/user/login', methods=['POST'])
def login():
    username = request.json['username']
    password = encode(password=request.json['password'])

    query = db.session.query(Usuario).filter_by(
        username=username, password=password).first()

    if query:
        usuario = usuario_model.Usuario(id=query.id, username=query.username, email=query.email, apellidos=query.apellidos,
                                        nombres=query.nombres, telefono=query.telefono, sitio=query.sitio, password='', admin=query.administrador)
        return jsonify({"status": 200, "usuario": usuario.serialize()})

    return jsonify({"status": 401, "message": "No existe el usuario"})


@app.route('/user/add/', methods=['POST'])
def create_usuario():
    data = request.json
    password = data['password']
    confirm_password = data['confirm_password']

    if password == confirm_password:
        usuario = Usuario(username=data['username'], email=data['email'], apellidos=data['apellidos'],
                          nombres=data['nombres'], telefono=data['telefono'], sitio=data['sitio'], password=encode(
                              password=password),
                          activo=True, administrador=False)

        db.session.add(usuario)
        db.session.commit()

        return jsonify({"status": 200, "message": "Usuario creado"})

    return jsonify({"status": 400, "message": "Error al crear el usuario"})


@app.route('/user/<int:id>', methods=['GET'])
def read_usuario(id):
    query = db.session.query(Usuario).filter_by(
        id=id, activo=True, administrador=False).first()

    if query:
        usuario = usuario_model.Usuario(id=query.id, username=query.username, email=query.email, apellidos=query.apellidos,
                                        nombres=query.nombres, telefono=query.telefono, sitio=query.sitio, password=query.password)
        return jsonify({"status": 200, "usuario": usuario.serialize()})

    return jsonify({"status": 400, "message": "No existe el usuario"})


@app.route('/user/update/<int:id>', methods=['PUT'])
def update_usuario(id):
    data = request.json
    password = data['password']
    confirm_password = data['confirm_password']

    query = db.session.query(Usuario).filter_by(
        id=id, activo=True, administrador=False).first()

    if query and password == confirm_password:
        query.username = data['username']
        query.email = data['email']
        query.apellidos = data['apellidos']
        query.nombres = data['nombres']
        query.telefono = data['telefono']
        query.sitio = data['sitio']
        if query.password == password:
            query.password = query.password
        else:
            query.password = encode(password=password)
        db.session.commit()

        return jsonify({"status": 200, "message": "Usuario actualizado"})

    return jsonify({"status": 400, "message": "Error al actualizar el usuario"})


@app.route('/user/delete/<int:id>', methods=['DELETE'])
def delete_usuario(id):
    query = db.session.query(Usuario).filter_by(
        id=id, activo=True, administrador=False).first()

    if query:
        db.session.delete(query)
        db.session.commit()
        return jsonify({"status": 200, "message": "Usuario eliminado"})

    return jsonify({"status": 400, "message": "Error al eliminar el usuario"})


@app.route('/user/', methods=['GET'])
def get_usuarios():
    query = db.session.query(Usuario).filter_by(
        activo=True, administrador=False).all()

    if query:
        usuarios = []
        for q in query:
            usuario = usuario_model.Usuario(id=q.id, username=q.username, email=q.email, apellidos=q.apellidos,
                                            nombres=q.nombres, telefono=q.telefono, sitio=q.sitio, password=q.password)
            usuarios.append(usuario.serialize())
        return jsonify({"status": 200, "usuarios": usuarios})

    return jsonify({"status": 400, "message": "No existen registros"})


@app.route('/history/', methods=['GET'])
def get_history():
    query = db.session.query(Historial).all()

    if query:
        historial = []
        for q in query:
            print(q)
            hist = historial_model.Historial(
                id=q.id, fecha=q.fecha, nombre_apellido=q.nombre_apellido)
            historial.append(hist.serialize())
        return jsonify({"status": 200, "historial": historial})

    return jsonify({"status": 400, "message": "No existen registros"})


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True, port=4000)
