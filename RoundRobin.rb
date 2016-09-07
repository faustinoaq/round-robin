# Algoritmo de planificación por turnos (Round Robin)
# @faustinoaq Agosto 7, 2016

class RoundRobin
  def initialize(n, quantum, archivo)
    @n = n
    @quantum = quantum
    @archivo = archivo
    @procesos = (1..@n).map do |i|
      {
        :pcb    => "P#{i}",
        :id     => "0#{i}",
        # :inst   => rand(50, 100),
        :inst   => 100,
        :estado => "N",
        :pos    => i,
      }
    end
    titulo
    listo
    trabajar
    guardar
  end

  def titulo
    @buffer = ["Modelo de 4 estados\n"]
    @buffer << "Cantidad de procesos: #{@n}\n"
    @buffer << "Quantum: #{@quantum}\n"
    @buffer << "Archivo: #{@archivo}\n"
    almacenar
  end

  def almacenar
    titulo = {
      :pcb    => "Proceso",
      :id     => "ID de proceso",
      :inst   => "Instruciones por ejecucion",
      :estado => "Estado",
      :pos    => "Posición en cola",
    }
    @procesos[0].keys.each { |k|
      @buffer << "#{titulo[k]}".rjust(30)
      @procesos.each { |p|
        @buffer << "\t#{p[k]}"
      }
      @buffer << "\n"
    }
    @buffer << "\n"
  end

  def guardar
    File.write(@archivo, @buffer.join)
    puts "Se guardó #{@archivo} correctamente"
  rescue Exception => e
    abort "Error al guardar #{@archivo} #{e}"
  end

  def listo
    @procesos.each { |p| p[:estado] = "L" }
    almacenar
  end

  def trabajar
    until terminado
      @procesos.each { |p| procesar(p) }
    end
    reposicionar
    almacenar
  end

  def reposicionar
    posicion = 0
    @procesos.each do |p|
      if p[:estado] == "T"
        p[:pos] = 0
      else
        posicion += 1
        p[:pos] = posicion
      end
    end
  end

  def terminado
    @procesos.each do |p|
      if p[:estado] != "T"
        return false
      end
    end
    return true
  end

  def procesar(p)
    if p[:inst] > @quantum
      p[:inst] -= @quantum
      p[:estado] = "E"
      reposicionar
      almacenar
      p[:estado] = "L"
    elsif p[:estado] != "T"
      p[:inst] = 0
      p[:estado] = "E"
      reposicionar
      almacenar
      p[:estado] = "T"
    end
  end
end

RoundRobin.new(ARGV[0].to_i, ARGV[1].to_i, "ruby.txt")
