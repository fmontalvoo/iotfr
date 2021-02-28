from django.shortcuts import render
from django.shortcuts import redirect
from django.urls import reverse_lazy
from django.utils.decorators import method_decorator
from django.views.decorators.cache import never_cache
from django.views.decorators.csrf import csrf_protect
from django.views.generic.edit import FormView
from django.contrib.auth import login, logout
from django.http import HttpResponseRedirect
from django.views.generic import TemplateView, CreateView, ListView, UpdateView, DeleteView

from .models import Usuario
from .forms import LoginForm ,UsuarioForm

# Create your views here.
class Inicio(TemplateView):
    template_name = 'index.html'

class CrearUsuario(CreateView):
    model = Usuario
    form_class = UsuarioForm
    template_name = 'pages/usuario/crear.html'
    success_url = reverse_lazy('usuario:listar')

class ListarUsuario(ListView):
    model = Usuario
    template_name = 'pages/usuario/lista.html'
    context_object_name = 'usuarios'
    queryset = model.objects.filter(activo=True, administrador=False)

class EditarUsuario(UpdateView):
    model = Usuario
    form_class = UsuarioForm
    template_name = 'pages/usuario/crear.html'
    success_url = reverse_lazy('usuario:listar')

class EliminarUsuario(DeleteView):
    model = Usuario
    template_name = 'pages/usuario/eliminar.html'
    success_url = reverse_lazy('usuario:listar')

class Login(FormView):
    template_name = 'pages/usuario/login.html'
    form_class = LoginForm
    success_url = reverse_lazy('index')

    @method_decorator(csrf_protect)
    @method_decorator(never_cache)
    def dispatch(self, request, *args, **kwargs):
        if request.user.is_authenticated:
            return HttpResponseRedirect(self.get_success_url())
        else:
            return super(Login, self).dispatch(request, *args, **kwargs)

    def form_valid(self, form):
        login(self.request, form.get_user())
        return super(Login, self).form_valid(form)


def logoutUsuario(request):
    logout(request)
    return HttpResponseRedirect('/usuario/login')
