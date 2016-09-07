# coding: utf-8
# Algoritmo de planificación por turnos (Round Robin)
# @faustinoaq Agosto 7, 2016

from random import randint
from sys import argv


class RoundRobin():

    def __init__(self, n, quantum, archivo):
        self.n = n
        self.quantum = quantum
        self.archivo = archivo
        self.buffer = []
        self.procesos = []
        for i in range(1, self.n + 1):
            self.procesos.append({
                "pcb": "P{}".format(i),
                "id": "0{}".format(i),
                # "inst": randint(50, 100),
                "inst": 100,
                "estado": "N",
                "pos": i
            })
        self.titulo()
        self.listo()
        self.trabajar()
        self.guardar()

    def titulo(self):
        self.buffer.append("Algoritmo de planificación Round Robin\n")
        self.buffer.append("Cantidad de procesos: {}\n".format(self.n))
        self.buffer.append("Quantum: {}\n".format(self.quantum))
        self.buffer.append("Archivo: {}\n".format(self.archivo))
        self.almacenar()

    def almacenar(self):
        titulo = {
            "pcb": "Proceso",
            "id": "ID de proceso",
            "inst": "Instruciones por ejecucion",
            "estado": "Estado",
            "pos": "Posición en cola"
        }
        for k in self.procesos[0]:
            self.buffer.append(titulo[k])
            for p in self.procesos:
                self.buffer.append("\t{}".format(p[k]))
            self.buffer.append("\n")
        self.buffer.append("\n")

    def guardar(self):
        try:
            with open(self.archivo, "w") as f:                                                                                                                                         
                f.write("".join(self.buffer))                                                                                                                                                                     
                f.close() 
            print("Se guardó {} correctamente".format(self.archivo))
        except:
            raise("Error al guardar {}".format(self.archivo))

    def listo(self):
        for p in self.procesos:
            p["estado"] = "L"
        self.almacenar()

    def trabajar(self):
        while not self.terminado():
            for p in self.procesos:
                self.procesar(p)
        self.reposicionar()
        self.almacenar()

    def reposicionar(self):
        posicion = 0
        for p in self.procesos:
            if p["estado"] == "T":
                p["pos"] = 0
            else:
                posicion += 1
                p["pos"] = posicion

    def terminado(self):
        for p in self.procesos:
            if p["estado"] != "T":
                return False
        return True

    def procesar(self, p):
        if p["inst"] > self.quantum:
            p["inst"] -= self.quantum
            p["estado"] = "E"
            self.reposicionar()
            self.almacenar()
            p["estado"] = "L"
        elif p["estado"] != "T":
            p["inst"] = 0
            p["estado"] = "E"
            self.reposicionar()
            self.almacenar()
            p["estado"] = "T"

RoundRobin(int(argv[1]), int(argv[2]), "python.txt")
