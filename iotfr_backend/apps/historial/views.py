from django.shortcuts import render
from django.views.generic import ListView

from .models import Historial

# Create your views here.
class ListarHistorial(ListView):
    model = Historial
    template_name = 'pages/historial/lista.html'
    context_object_name = 'registros'
    queryset = model.objects.all()