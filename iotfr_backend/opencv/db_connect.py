import psycopg2
from psycopg2 import Error

from datetime import datetime

def insert_into_historial(fecha_actual=datetime.today().strftime("%d/%m/%Y %H:%M:%S"), nombre_apellido="Desconocido"):
	try:
		print("Conectando...")
		connection = psycopg2.connect(user="damian", password="damian", host="localhost", port="5432", database="tesisdb")

		cursor = connection.cursor()

		count = cursor.execute('SELECT count(id) FROM historial_historial')
		
		id = cursor.fetchone()[0]

		query = "INSERT INTO historial_historial VALUES('{id}', '{nombre_apellido}', '{fecha}')".format(id=(id + 1), fecha=fecha_actual, nombre_apellido=nombre_apellido)
		
		cursor.execute(query)
		connection.commit()

	except (Exception, Error) as error:
		print("Error al conectarse a la base", error)
	finally:
		if (connection):
			cursor.close()
			connection.close()
			print("Cerrando conexion con la base.")
