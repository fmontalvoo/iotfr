from django.db import models
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager

# Create your models here.
class UsuarioManager(BaseUserManager):

    def create_user(self, email, username, nombres, apellidos, password=None):
        if not email:
            raise ValueError('El usuario debe tener un email')

        usuario = self.model(
            username = username,
            email = self.normalize_email(email),
            nombres = nombres,
            apellidos = apellidos
        )

        usuario.set_password(password)
        usuario.save()
        return usuario

    def create_superuser(self, email, username, nombres, apellidos, password):
        usuario = self.create_user(
            email,
            username = username,
            nombres = nombres,
            apellidos = apellidos,
            password = password
        )

        usuario.administrador = True
        usuario.save()
        return usuario

class Usuario(AbstractBaseUser):
    username = models.CharField('Nombre de usuario', unique=True, max_length=100)
    email = models.EmailField('Correo electrónico', unique=True, max_length=250)
    apellidos = models.CharField('Apellidos', max_length=200, blank=False, null=False)
    nombres = models.CharField('Nombres', max_length=200, blank=False, null=False)
    telefono = models.CharField('Teléfono', max_length=20, blank=True, null=True)
    sitio = models.CharField('Nombre del sitio', max_length=50, blank=True, null=True)
    activo = models.BooleanField(default=True)
    administrador = models.BooleanField(default=False)
    objects = UsuarioManager()

    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = ['email', 'apellidos', 'nombres']

    def __str__(self):
        return '{nombres} {apellidos}'.format(apellidos=self.apellidos, nombres=self.nombres)

    def has_perm(self, perm, obj=None):
        return True
    
    def has_module_perms(self, app_label):
        return True
    
    @property
    def is_staff(self):
        return self.administrador
