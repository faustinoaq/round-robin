# Algoritmo de planificación por turnos (Round Robin)
# @faustinoaq Sept, 2016

class Proceso
  property pcb : String,
    id : String,
    instru : Int32,
    estado : String,
    posic : Int32
  def initialize(@pcb, @id, @instru, @estado, @posic)
  end
end

struct RoundRobin 
  @buffer = [] of String
  @procesos = [] of Proceso

  def initialize(@n : Int32, @quantum : Int32, @archivo : String)
    @procesos = (1..@n).map do |i|
      Proceso.new("P#{i}", "0#{i}", 100, "N", i)
    end
    titulo_buffer
    cola_listo
    procesar_cola
    guardar_archivo
  end

  private def titulo_buffer
    @buffer << "Algoritmo de planificación Round Robin\n"
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
    File.write(@archivo, @buffer.join)
    puts "#{@archivo} guardado correctamente"
  rescue
    abort "Error al guardar #{@archivo}"
  end
end

RoundRobin.new(ARGV[0].to_i, ARGV[1].to_i, "crtest.txt")
