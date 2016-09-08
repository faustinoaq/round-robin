package Java;

import java.io.File;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.util.Random;
import java.util.Scanner; 
import java.util.ArrayList;

/**
 * Algoritmo de planificación por turnos (Round Robin)
 * @faustinoaq Agosto 7, 2016
 * N(Nuevo) L(Listo) E(Ejecución) B(Bloqueado) T(Terminado)
 */

public class RoundRobin {
    // Aleatorios
    // Random rand = new Random();
    // int quantum = 1 + rand.nextInt(9);;
    // int cantidad = 1 + rand.nextInt(4);;

    // Fijos
    int quantum;
    int cantidad;
    String archivo = "java.txt";
    ArrayList<String> buffer = new ArrayList<>();
    Proceso[] procesos;

    RoundRobin (int cantidad, int quantum) {
        // fijarDatos();
        this.quantum = quantum;
        this.cantidad = cantidad;
        this.procesos = new Proceso[cantidad];
    }

    public static void main(String[] args) {
        RoundRobin bloque = new RoundRobin(Integer.parseInt(args[0]), Integer.parseInt(args[1]));
        try {
            bloque.iniciar();
            System.out.println("Se guardó " + bloque.archivo + " correctamente");
        } catch (Exception e){
            System.out.println("Ha ocurrido un error al ejecutar el programa");
        }
    }

    void fijarDatos() {
        Scanner scan = new Scanner(System.in);
        System.out.println("Modelo de Estados\n");
        System.out.println("Valor del quantum: ");
        this.quantum = scan.nextInt();
        System.out.println("Cantida de procesos: ");
        this.cantidad = scan.nextInt();
        System.out.println("Nombre del archivo: ");
        this.archivo = scan.next();
        this.procesos = new Proceso[cantidad];
    }

    void iniciar() {
        Random rand = new Random();
        Proceso p;
        int i;
        for (i = 0; i < this.cantidad; i++) {
            p = new Proceso();
            p.pcb = "PC" + Integer.toString(i+1);
            p.id = "0" + Integer.toString(i+1);
            // Scanner scan = new Scanner(System.in);
            // System.out.println("Nombre del archivo: ");
            // this.instruc = scan.nextInt();
            // p.instruc = 50 + rand.nextInt(50);
            p.instruc = 100;
            p.estado = "N";
            p.posic = i + 1;
            procesos[i] = p;
        }
        titulo();
        almacenar();
        for (i = 0; i < this.cantidad; i++) {
            procesos[i].estado = "L";
        }
        almacenar();
        trabajar();
        guardar();
    }


    void titulo() {
        this.buffer.add("Modelo de estados\n");
        this.buffer.add("N(Nuevo) L(Listo) E(Ejecución) B(Bloqueado) T(Terminado)\n");
        this.buffer.add("Cantidad de procesos:" + this.cantidad + "\n");
        this.buffer.add("Quantum: " + this.quantum + "\n");
        this.buffer.add("Archivo: " + this.archivo + "\n");
    }

    void guardar() {
        try {
            File a;
            a = new File(this.archivo);
            try (BufferedWriter b = new BufferedWriter(new FileWriter(a))) {
                String buf = String.join("", this.buffer);
                b.write(buf);
            } catch (Exception e) {
                System.out.println("Error al escribir el archivo " + this.archivo);
            }
        } catch (Exception e) {
            System.out.println("Error al abrir el archivo " + this.archivo);
        }
    }

    void reposicionar() {
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

    void almacenar() {
        this.buffer.add("PCB");
        for(Proceso p : procesos) {
            this.buffer.add("\t");
            this.buffer.add(p.pcb);
        }
        this.buffer.add("\nID Proc");
        for(Proceso p : procesos) {
            this.buffer.add("\t");
            this.buffer.add(p.id);
        }
        this.buffer.add("\nInsxEje");
        for(Proceso p : procesos) {
            this.buffer.add("\t");
            this.buffer.add(Integer.toString(p.instruc));
        }
        this.buffer.add("\nEstado");
        for(Proceso p : procesos) {
            this.buffer.add("\t");
            this.buffer.add(p.estado);
        }
        this.buffer.add("\nPosicn");
        for(Proceso p : procesos) {
            this.buffer.add("\t");
            this.buffer.add(Integer.toString(p.posic));
        }
        this.buffer.add("\n\n");
    }

    void trabajar() {
        while (ejecutar()) {
            for (Proceso p : procesos) {
                modificar(p);
            } 
        }
        reposicionar();
        almacenar();
    }

    boolean ejecutar() {
        for (Proceso p : procesos) {
            if (!"T".equals(p.estado)) {
                return true;
            }
        }
        return false;
    }

    void modificar(Proceso p) {
        if (p.estado.equals("B")) {
            siguienteEstado(p);
        }else if (p.instruc > quantum) {
            p.instruc -= quantum;
            p.estado = "E";
            almacenar();
            siguienteEstado(p);
        } else if (!"T".equals(p.estado)) {
            p.instruc = 0;
            p.estado = "E";
            reposicionar();
            almacenar();
            siguienteEstado(p);
        }
    }

    void siguienteEstado(Proceso p) {
        // Random bloqueo = new Random();
        // if (bloqueo.nextInt(3) == 1) {
            // p.estado = "B";
        // } else if (p.instruc == 0) {
        if (p.instruc == 0) {
            p.estado = "T";
        } else {
            p.estado = "L";
        }
    }
}
