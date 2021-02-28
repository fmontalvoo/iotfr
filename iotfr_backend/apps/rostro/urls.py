from django.urls import path
from django.contrib.auth.decorators import login_required

from .views import Registro

urlpatterns = [
    path('', login_required(Registro.as_view()), name='registro'),
]