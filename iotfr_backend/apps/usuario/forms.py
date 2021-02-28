from django import forms
from django.contrib.auth.forms import AuthenticationForm

from .models import Usuario

class LoginForm(AuthenticationForm):
    def __init__(self, *args, **kwargs):
        super(LoginForm, self).__init__(*args, **kwargs)
        self.fields['username'].widget.attrs['class'] = 'form-control'
        self.fields['username'].widget.attrs['placeholder'] = 'Nombre de usuario'

        self.fields['password'].widget.attrs['class'] = 'form-control'
        self.fields['password'].widget.attrs['placeholder'] = 'Contraseña'

class UsuarioForm(forms.ModelForm):
    password = forms.CharField(label='Contraseña', widget=forms.PasswordInput(
        attrs={
            'id': 'password',
            'class': 'form-control',
            'placeholder': 'Ingrese su contraseña',
            'required': 'required'
        }
    ))
    confirm_password = forms.CharField(label='Contraseña de confirmacion', widget=forms.PasswordInput(
        attrs={
            'id': 'confirm_password',
            'class': 'form-control',
            'placeholder': 'Vuelva a ingresar su contraseña',
            'required': 'required'
        }
    ))

    class Meta:
        model = Usuario
        fields = ('username', 'email', 'nombres', 'apellidos', 'telefono', 'sitio')
        widgets = {
            'username': forms.TextInput(
                attrs={
                    'class': 'form-control',
                    'placeholder': 'Nombre de usuario',
                }
            ),
            'email': forms.EmailInput(
                attrs={
                    'class': 'form-control',
                    'placeholder': 'Correo electrónico',
                }
            ),
            'nombres': forms.TextInput(
                attrs={
                    'class': 'form-control',
                    'placeholder': 'Nombres',
                }
            ),
            'apellidos': forms.TextInput(
                attrs={
                    'class': 'form-control',
                    'placeholder': 'Apellidos',
                }
            ),
            'telefono': forms.TextInput(
                attrs={
                    'class': 'form-control',
                    'placeholder': 'Teléfono',
                }
            ),
            'sitio': forms.TextInput(
                attrs={
                    'class': 'form-control',
                    'placeholder': 'Nombre del sitio',
                }
            ),
            
        }

    def clean_confirm_password(self):
        password = self.cleaned_data.get('password')
        confirm_password = self.cleaned_data.get('confirm_password')
        if password != confirm_password:
            raise forms.ValidationError('Contraseñas no coinciden!')
        return confirm_password
        
    def save(self, commit=True):
        user = super().save(commit=False)
        user.set_password(self.cleaned_data['password'])
        if commit:
            user.save()
        return user