import java.io.File;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.util.ArrayList;

/**
 * Algoritmo de planificación por turnos (Round Robin)
 * @faustinoaq Sept, 2016
 */

class RoundRobin {
    int n;
    int quantum;
    String archivo;
    Proceso[] procesos;
    ArrayList<String> buffer;

    RoundRobin (int n, int quantum, String archivo) {
        this.n = n;
        this.quantum = quantum;
        this.archivo = archivo;
        this.procesos = new Proceso[n];
        this.buffer = new ArrayList<>();
        Proceso p;
        for (int i = 0; i < this.n; i++) {
            p = new Proceso();
            p.pcb = "P" + Integer.toString(i+1);
            p.id = "0" + Integer.toString(i+1);
            p.instru = 100;
            p.estado = "N";
            p.posic = i + 1;
            procesos[i] = p;
        }
        tituloBuffer();
        colaListo();
        procesarCola();
        guardarArchivo();
    }

    public static void main(String[] args) {
        new RoundRobin(Integer.parseInt(args[0]),
                       Integer.parseInt(args[1]),
                       "jatest.txt");
    }

    private void tituloBuffer() {
        this.buffer.add("Algoritmo de planificación Round Robin\n");
        this.buffer.add("N(Nuevo) L(Listo) E(Ejecución) T(Terminado)\n");
        this.buffer.add("Cantidad de procesos: " + this.n + "\n");
        this.buffer.add("Quantum: " + this.quantum + "\n");
        guardarBuffer();
    }

    private void guardarBuffer() {
        this.buffer.add("\nProceso");
        for(Proceso p : procesos) {
            this.buffer.add("\t" + p.pcb);
        }
        this.buffer.add("\nID");
        for(Proceso p : procesos) {
            this.buffer.add("\t" + p.id);
        }
        this.buffer.add("\nInstruc");
        for(Proceso p : procesos) {
            this.buffer.add("\t" + Integer.toString(p.instru));
        }
        this.buffer.add("\nEstado");
        for(Proceso p : procesos) {
            this.buffer.add("\t" + p.estado);
        }
        this.buffer.add("\nPosic");
        for(Proceso p : procesos) {
            this.buffer.add("\t" + Integer.toString(p.posic));
        }
        this.buffer.add("\n");
    }

    private void colaListo() {
        for (int i = 0; i < this.n; i++) {
            this.procesos[i].estado = "L";
        }
        guardarBuffer();
    }

    private void procesarCola() {
        while (procesosNoTerminados()) {
            for (Proceso p : procesos) {
                trabajarProceso(p);
            } 
        }
        reposicionarCola();
        guardarBuffer();
    }

    private void reposicionarCola() {
        int posicion = 0;
        for (Proceso p : procesos) {
            if (p.estado.equals("T")) {
                p.posic = 0;
            } else {
                posicion += 1;
                p.posic = posicion;
            }
        }
    }

    private boolean procesosNoTerminados() {
        for (Proceso p : procesos) {
            if (!"T".equals(p.estado)) {
                return true;
            }
        }
        return false;
    }

    private void trabajarProceso(Proceso p) {
        if (p.instru > quantum) {
            p.instru -= quantum;
            p.estado = "E";
            guardarBuffer();
            p.estado = (p.instru == 0) ? "T" : "L";
        } else if (!"T".equals(p.estado)) {
            p.instru = 0;
            p.estado = "E";
            reposicionarCola();
            guardarBuffer();
            p.estado = "T";
        }
    }

    private void guardarArchivo() {
        try {
            File f = new File(this.archivo);
            FileWriter fw = new FileWriter(f);
            BufferedWriter bw = new BufferedWriter(fw);
            bw.write(String.join("", this.buffer));
            bw.close();
            System.out.println(this.archivo + " guardado correctamente");
        } catch (Exception e) {
            System.out.println("Error al guardar " + this.archivo);
        }
    }
}
