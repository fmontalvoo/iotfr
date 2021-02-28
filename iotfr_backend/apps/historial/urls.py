from django.urls import path
from django.contrib.auth.decorators import login_required

from .views import ListarHistorial

urlpatterns = [
    path('listar/', login_required(ListarHistorial.as_view()), name='listar'),
]
