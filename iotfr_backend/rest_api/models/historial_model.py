class Historial:

    def __init__(self, id, nombre_apellido, fecha):
        self.id = id
        self.nombre_apellido = nombre_apellido
        self.fecha = fecha

    def serialize(self):
        return {
            "id": self.id,
            "nombre_apellido": self.nombre_apellido,
            "fecha": self.fecha
        }
