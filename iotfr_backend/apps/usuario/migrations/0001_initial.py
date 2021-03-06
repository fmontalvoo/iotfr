# Generated by Django 3.0.5 on 2020-06-18 03:24

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Usuario',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('username', models.CharField(max_length=100, unique=True, verbose_name='Nombre de usuario')),
                ('email', models.EmailField(max_length=250, unique=True, verbose_name='Correo electrónico')),
                ('apellidos', models.CharField(max_length=200, verbose_name='Apellidos')),
                ('nombres', models.CharField(max_length=200, verbose_name='Nombres')),
                ('telefono', models.CharField(blank=True, max_length=20, null=True, verbose_name='Teléfono')),
                ('sitio', models.CharField(blank=True, max_length=50, null=True, verbose_name='Nombre del sitio')),
                ('activo', models.BooleanField(default=True)),
                ('administrador', models.BooleanField(default=False)),
            ],
            options={
                'abstract': False,
            },
        ),
    ]
