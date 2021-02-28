# Para usar en una laptop, o con un GPU (el proceso es más lento pero más preciso) --detection-method cnn
# Para usar en una Raspberry Pi (el proceso es más rápido, menos preciso) --detection-method hog

#importamos las librerias necesarias
from imutils import paths
import face_recognition
import argparse
import pickle
import cv2
import os

# leemos desde la ruta las imágenes de entrada en nuestra carpeta dataset
print("[INFO] quantifying faces...")
imagePaths = list(paths.list_images('dataset'))

# inicializamos la lista de codificaciones y nombres de las caras conocidas
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
# codificamos las imágenes
f = open('encodings.pickle', "wb")
f.write(pickle.dumps(data))
f.close()
