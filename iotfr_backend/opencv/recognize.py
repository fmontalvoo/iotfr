#!/usr/bin/python3
# Para usar en una laptop, o con un GPU (el proceso es más lento pero más preciso) --detection-method cnn
# Para usar en una Raspberry Pi (el proceso es más rápido, menos preciso) --detection-method hog

# importamos los paquetes necesarios
import imutils
from imutils import paths
from imutils.video import VideoStream
from imutils.video import FPS
import face_recognition
import pickle
import time
import cv2
import os

import sys
sys.path.append("..")

from datetime import datetime

from notifications.notification import send_notification
from db_connect import insert_into_historial

print("[INFO] quantifying faces...")
imagePaths = list(paths.list_images('faces_register'))
#print(imagePaths)

# inicializamos la lista de imagtenes y nombres conocidos
knownEncodings = []
knownNames = []

# recorremos con un for las rutas de la imagen
for (i, imagePath) in enumerate(imagePaths):
	# extraemos el nombre de la persona de la ruta de la imagen
	print("[INFO] processing image {}/{}".format(i + 1,
		len(imagePaths)))
	name = imagePath.split(os.path.sep)[-2]

	# cargamos la imagen de entrada y la convertimos en RGB 
	image = cv2.imread(imagePath)
	rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

	# detectamos las coordenadas (x, y) de los cuadros delimitadores correspondiente a cada cara de la imagen de entrada
	# seleccionamos el método con el que hará el reconocimiento: cnn o hog
	boxes = face_recognition.face_locations(rgb,
		model='hog')

	# calculamos la delimitación de la cara
	encodings = face_recognition.face_encodings(rgb, boxes)

	# recorremos con un for las imágenes codificadas
	for encoding in encodings:
		# agregamos cada codificación + nombre a nuestro conjunto de nombres y codificaciones conocidos
		knownEncodings.append(encoding)
		knownNames.append(name)

# mostramos los nombres correspondientes a la cara detectada
print("[INFO] serializing encodings...")
data = {"encodings": knownEncodings, "names": knownNames}
f = open('encodings.pickle', "wb")
f.write(pickle.dumps(data))
f.close()


print("[INFO] loading encodings + face detector...")
# comparamos
data = pickle.loads(open('encodings.pickle', "rb").read())
detector = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')

# Inicializamos la transmisión de video con la cámara IP
print("[INFO] starting video stream...")
#vs = VideoStream(src=0).start()
#vs = VideoStream(usePiCamera=True).start()
#vs = cv2.VideoCapture("rtsp://admin:12345@192.168.10.20/h264/ch1/main/av_stream")
#vs = cv2.VideoCapture("rtsp://admin:12345@192.168.10.20:554/MJPEG-4/ch1/sub/av_stream")
vs = cv2.VideoCapture("rtsp://admin:Patito123@192.168.10.20:554/mpeg4/ch1/main/av_stream")
#sivs = cv2.VideoCapture("rtsp://admin:Patito123@192.168.10.20:554/MJPEG-4/ch1/sub/av_stream")
#vs = cv2.VideoCapture("rtsp://admin:Patito123@192.168.10.20:554/MJPEG/ch1/sub/av_stream")
#vs = cv2.VideoCapture("rtsp://admin:Patito123@192.168.10.20:554/h264/ch1/main/av_stream")

time.sleep(2.0)

# iniciar el contador de FPS
fps = FPS().start()

start = time.time()
end = start

seconds = 0
minutes = 0

MINUTES_NOTIFICATION = 0
notification = True
match_notification = ''

# recorremos los fotogramas de la secuencia del archivo de vídeo
while True:
	seconds = end - start
	if int(seconds) == 30:
		minutes += 1
		start = time.time()
	if minutes > MINUTES_NOTIFICATION:
		minutes = 0
		notification = True
	print("{mins}:{secs:.2f}".format(mins=minutes, secs=seconds))
	end = time.time()

	# tomamos el fotograma de la secuencia de video y cambiamos el tamaño 
	# para acelerar el procesamiento
	ret, frame = vs.read()
	#frame = vs.read()
	frame = imutils.resize(frame, width=500)
	
	# convertimos el fotograma de entrada a escala de grises (para detección de rostros) 
	# convertimos el fotograma de BGR a RGB (para reconocimiento de rostros)
	gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
	rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)

	# detectamos los rostros en el marco de escala de grises
	rects = detector.detectMultiScale(gray, scaleFactor=1.1,
		minNeighbors=5, minSize=(30, 30),
		flags=cv2.CASCADE_SCALE_IMAGE)

	# OpenCV nos devuelve las coordenadas del cuadro delimitador en el orden (x, y, w, h) pero las necesitamos 
	# en el orden (superior, derecha, inferior, izquierda), por lo que tenemos que reordenar
	boxes = [(y, x + w, y + h, x) for (x, y, w, h) in rects]

	# calculamos las incrustaciones faciales para cada cuadro delimitador de caras
	encodings = face_recognition.face_encodings(rgb, boxes)
	names = []

	# recorremos con un for las incrustaciones faciales
	for encoding in encodings:
		# intentamos hacer coincidir cada cara en la imagen de entrada con nuestras imágenes codificaciones conocidas
		matches = face_recognition.compare_faces(data["encodings"],	
			encoding)
		name = "Unknown"

		# aqui verificamos si encontramos alguna coincidencia
		if True in matches:
			# encontramos los índices de todas las caras coincidentes y luego inicializamos un diccionario para contar 
			# el número total de veces que se comparó cada cara
			matchedIdxs = [i for (i, b) in enumerate(matches) if b]
			counts = {}

			# recorremos con un for los índices coincidentes y mantenemos un recuento para cada cara reconocida
			for i in matchedIdxs:
				name = data["names"][i]
				counts[name] = counts.get(name, 0) + 1

			# determinamos la cara reconocida con el mayor número de coincidencias
			name = max(counts, key=counts.get)
			if name != "Unknown":
				match_notification = name

			if notification and int(seconds) == 0:
				print("Enviar notificacion: {mn}".format(mn=match_notification))
				fecha_actual = datetime.today().strftime("%d/%m/%Y %H:%M:%S")
				n_a = match_notification.split('_')
				nombre_apellido = n_a[0].capitalize() + ' ' +  n_a[1].capitalize()
				send_notification(
					to='eO4n_KwRSI6SeAUtgZLReY:APA91bFeA9DXW-AW7o2Fv3mrPRzViDlT5qQzHB6GReSL2oi5cGqNq1hCtVxVQbfBhzhxZhzdnJuWb0yV387w7VpFu4HCMEm8pU_7owavetA5tK_o2pr37jbuiFYVxbrZdhG1201PjGTm',
					title='Detección',
					subtitle='Se encontró a {n_a} el {fecha}'.format(n_a=nombre_apellido, fecha=fecha_actual),
					description='Notifiacion: se encontró a {n_a} el {fecha}'.format(n_a=nombre_apellido, fecha=fecha_actual)			
				)
				insert_into_historial(
					fecha_actual=fecha_actual,
					nombre_apellido=nombre_apellido
				)
				notification = False
		
		# actualizamos la lista de nombres
		names.append(name)

	# recorremos con un for las caras reconocidas
	for ((top, right, bottom, left), name) in zip(boxes, names):
		# colocamos el nombre de la cara coincidente de la imagen
		cv2.rectangle(frame, (left, top), (right, bottom),
			(0, 255, 0), 2)
		y = top - 15 if top - 15 > 15 else top + 15
		cv2.putText(frame, name, (left, y), cv2.FONT_HERSHEY_SIMPLEX,
			0.75, (0, 255, 0), 2)

	# mostramos la imagen en la pantalla
	cv2.imshow("Frame", frame)
	key = cv2.waitKey(1) & 0xFF

	# q para salir 
	if key == ord("q"):
		break

	# aquí actualizamos el contador de FPS
	fps.update()

# detenemos el conteo y mostramos la información de los FPS
fps.stop()
print("[INFO] elasped time: {:.2f}".format(fps.elapsed()))
print("[INFO] approx. FPS: {:.2f}".format(fps.fps()))

# limpiamos
cv2.destroyAllWindows()
vs.stop()
