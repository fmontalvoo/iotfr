import subprocess
import requests as http

from django.shortcuts import render
from django.views.generic import View


# Create your views here.
class Registro(View):
    template_name = 'pages/rostro/registro.html'

    def get(self, request, *args, **kwargs):
        return render(request, self.template_name)

    def post(self, request, *args, **kwargs):
        nombre = request.POST.get("nombre")
        apellido = request.POST.get("apellido")
       	peticion = make_request(nombre, apellido)
       	return render(request, self.template_name, {"response": peticion.status_code})

def make_request(nombre, apellido):
	URL = 'http://localhost:4001/register/faces'
	body = {"nombre": nombre, "apellido": apellido}
	response = http.post(URL, json=body)
	return response
