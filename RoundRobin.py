# coding: utf-8
# Algoritmo de planificación por turnos (Round Robin):
# @faustinoaq Sept, 2016

from sys import argv


class Proceso():

    def __init__(self, pcb, id, instru, estado, posic):
        self.pcb = pcb
        self.id = id
        self.instru = instru
        self.estado = estado
        self.posic = posic


class RoundRobin():

    def __init__(self, n, quantum, archivo):
        self.n = n
        self.quantum = quantum
        self.archivo = archivo
        self.buffer = []
        self.procesos = [
            Proceso("P{}".format(i), "0{}".format(i), 100, "N", i)
            for i in range(1, self.n + 1)
        ]
        self.titulo_buffer()
        self.cola_listo()
        self.procesar_cola()
        self.guardar_archivo()

    def titulo_buffer(self):
        self.buffer = ["Algoritmo de planificación Round Robin\n"]
        self.buffer.append("N(Nuevo) L(Listo) E(Ejecución) T(Terminado)\n")
        self.buffer.append("Cantidad de procesos: {}\n".format(self.n))
        self.buffer.append("Quantum: {}\n".format(self.quantum))
        self.guardar_buffer()

    def guardar_buffer(self):
        self.buffer.append("\nProceso")
        for p in self.procesos:
            self.buffer.append("\t{}".format(p.pcb))
        self.buffer.append("\nID")
        for p in self.procesos:
            self.buffer.append("\t{}".format(p.id))
        self.buffer.append("\nInstruc")
        for p in self.procesos:
            self.buffer.append("\t{}".format(p.instru))
        self.buffer.append("\nEstado")
        for p in self.procesos:
            self.buffer.append("\t{}".format(p.estado))
        self.buffer.append("\nPosic")
        for p in self.procesos:
            self.buffer.append("\t{}".format(p.posic))
        self.buffer.append("\n")

    def cola_listo(self):
        for p in self.procesos:
            p.estado = "L"
        self.guardar_buffer()

    def procesar_cola(self):
        while self.procesos_no_terminados():
            for p in self.procesos:
                self.trabajar_proceso(p)
        self.reposicionar_cola()
        self.guardar_buffer()

    def reposicionar_cola(self):
        posicion = 0
        for p in self.procesos:
            if p.estado == "T":
                p.posic = 0
            else:
                posicion += 1
                p.posic = posicion

    def procesos_no_terminados(self):
        for p in self.procesos:
            if p.estado != "T":
                return True
        return False

    def trabajar_proceso(self, p):
        if p.instru > self.quantum:
            p.instru -= self.quantum
            p.estado = "E"
            self.guardar_buffer()
            p.estado = "T" if p.instru == 0 else "L"
        elif p.estado != "T":
            p.instru = 0
            p.estado = "E"
            self.reposicionar_cola()
            self.guardar_buffer()
            p.estado = "T"

    def guardar_archivo(self):
        try:
            with open(self.archivo, "w") as f:
                f.write("".join(self.buffer))
                f.close()
            print("{} guardado correctamente".format(self.archivo))
        except IOError:
            raise("Error al guardar {}".format(self.archivo))

RoundRobin(int(argv[1]), int(argv[2]), "pytest.txt")
