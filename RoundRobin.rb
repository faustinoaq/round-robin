# Algoritmo de planificación por turnos (Round Robin)
# @faustinoaq Sept, 2016

class Proceso
  attr_accessor :pcb, :id, :instru, :estado, :posic
  def initialize(pcb, id, instru, estado, posic)
    @pcb = pcb
    @id = id
    @instru = instru
    @estado = estado
    @posic = posic
  end
end

class RoundRobin
  def initialize(n, quantum, archivo)
    @n = n
    @quantum = quantum
    @archivo = archivo
    @procesos = (1..@n).map do |i|
      Proceso.new("P#{i}", "0#{i}", 100, "N", i)
    end
    titulo_buffer
    cola_listo
    procesar_cola
    puts "#{@archivo} guardado correctamente"
  end

  private def titulo_buffer
    @buffer = ["Algoritmo de planificación Round Robin\n"]
    @buffer << "N(Nuevo) L(Listo) E(Ejecución) T(Terminado)\n"
    @buffer << "Cantidad de procesos: #{@n}\n"
    @buffer << "Quantum: #{@quantum}\n"
    guardar_buffer
  end

  private def guardar_buffer
    @buffer << "\nProceso"
    @procesos.each do |p|
      @buffer << "\t#{p.pcb}"
    end
    @buffer << "\nID"
    @procesos.each do |p|
      @buffer << "\t#{p.id}"
    end
    @buffer << "\nInstruc"
    @procesos.each do |p|
      @buffer << "\t#{p.instru}"
    end
    @buffer << "\nEstado"
    @procesos.each do |p|
      @buffer << "\t#{p.estado}"
    end
    @buffer << "\nPosic"
    @procesos.each do |p|
      @buffer << "\t#{p.posic}"
    end
    @buffer << "\n"
    guardar_archivo
  end

  private def cola_listo
    @procesos.each do |p|
      p.estado = "L"
    end
    guardar_buffer
  end

  private def procesar_cola
    until procesos_terminados
      @procesos.each do |p|
        trabajar_proceso(p)
      end
    end
    reposicionar_cola
    guardar_buffer
  end

  private def reposicionar_cola
    posicion = 0
    @procesos.each do |p|
      if p.estado == "T"
        p.posic = 0
      else
        posicion += 1
        p.posic = posicion
      end
    end
  end

  private def procesos_terminados
    @procesos.each do |p|
      if p.estado != "T"
        return false
      end
    end
    return true
  end

  private def trabajar_proceso(p)
    if p.instru > @quantum
      p.instru -= @quantum
      p.estado = "E"
      guardar_buffer
      p.estado = p.instru == 0 ? "T" : "L"
    elsif p.estado != "T"
      p.instru = 0
      p.estado = "E"
      reposicionar_cola
      guardar_buffer
      p.estado = "T"
    end
  end

  private def guardar_archivo
    File.open(@archivo, 'a') do |f|
      f << @buffer.join
    end
    @buffer.clear
  rescue
    abort "Error al guardar #{@archivo}"
  end
end

RoundRobin.new(ARGV[0].to_i, ARGV[1].to_i, "rbtest.txt")
