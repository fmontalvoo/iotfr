# Generated by Django 3.0.5 on 2020-09-27 03:11

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Historial',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False)),
                ('nombre_apellido', models.CharField(max_length=500, verbose_name='Nombre y Apellido')),
                ('fecha', models.CharField(max_length=20, verbose_name='Fecha')),
            ],
            options={
                'verbose_name': 'Historial',
                'verbose_name_plural': 'Historial',
                'ordering': ['id'],
            },
        ),
    ]