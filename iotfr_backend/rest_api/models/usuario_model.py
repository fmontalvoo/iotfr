class Usuario:

    def __init__(self, id, username, email, apellidos, nombres, telefono, sitio, password, activo=True, admin=False):
        self.id = id
        self.username = username
        self.email = email
        self.apellidos = apellidos
        self.nombres = nombres
        self.telefono = telefono
        self.sitio = sitio
        self.password = password
        self.activo = activo
        self.admin = admin

    def serialize(self):
        return {
            "id": self.id,
            "username": self.username,
            "email": self.email,
            "apellidos": self.apellidos,
            "nombres": self.nombres,
            "telefono": self.telefono,
            "sitio": self.sitio,
            "password": self.password,
            "activo": self.activo,
            "admin": self.admin
        }
