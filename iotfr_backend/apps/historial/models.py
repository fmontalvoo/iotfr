from django.db import models

# Create your models here.

class Historial(models.Model):
    id = models.AutoField(primary_key=True)
    nombre_apellido = models.CharField(
        'Nombre y Apellido', max_length=500, blank=False, null=False)
    fecha = models.CharField('Fecha', max_length=20, blank=False, null=False)

    class Meta:
        verbose_name = 'Historial'
        verbose_name_plural = 'Historial'
        ordering = ['id']

    def __str__(self):
        return '{0}'.format(self.nombre_apellido)
