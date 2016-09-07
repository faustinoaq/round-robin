# Algoritmo de planificación por turnos (Round Robin)
# @faustinoaq Agosto 7, 2016

class RoundRobin
  @buffer = [] of String
  @procesos = [] of Hash(Symbol, Int32 | String)

  def initialize(@n : Int32, @quantum : Int32, @archivo : String)
    (1..@n).each do |i|
      @procesos << {
        :pcb     => "P#{i}",
        :id      => "0#{i}",
        :instruc => 0,
        :estado  => "N",
        :pos     => i,
      }
    end
  end

  def aleatorio
    @procesos.each do |p|
      # p[:instruc] = rand(50..100)
      p[:instruc] = 100
    end
    iniciar_metodos
  end

  def fijo
    @procesos.each do |p|
      print("Instruciones para #{p[:pcb]}: ")
      p[:instruc] = gets.to_s.to_i
    end
    iniciar_metodos
  end

  private def iniciar_metodos
    titulo_del_buffer
    cola_de_listo
    procesar_cola
    guardar_archivo
  end

  private def titulo_del_buffer
    @buffer << "Algoritmo de planificación Round Robin\n"
    @buffer << "N(Nuevo) L(Listo) E(Ejecución) B(Bloqueado) T(Terminado)\n"
    @buffer << "Cantidad de procesos: #{@n}\n"
    @buffer << "Quantum: #{@quantum}\n"
    @buffer << "Archivo: #{@archivo}\n"
    guardar_buffer
  end

  private def guardar_buffer
    encabezados = {
      :pcb     => "Proceso",
      :id      => "ID de proceso",
      :instruc => "Instruciones por ejecucion",
      :estado  => "Estado",
      :pos     => "Posición en cola",
    }
    encabezados.keys.each do |k|
      @buffer << "#{encabezados[k]}".rjust(26)
      @procesos.each do |p|
        @buffer << "\t#{p[k]}"
      end
      @buffer << "\n"
    end
    @buffer << "\n"
  end

  private def guardar_archivo
    File.write(@archivo, @buffer.join)
    puts("Se guardó #{@archivo} correctamente")
  rescue
    abort("Error al guardar el archivo #{@archivo}")
  end

  private def cola_de_listo
    @procesos.each do |p|
      p[:estado] = "L"
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
      if p[:estado] == "T"
        p[:pos] = 0
      else
        posicion += 1
        p[:pos] = posicion
      end
    end
  end

  private def procesos_terminados
    @procesos.each do |p|
      if p[:estado] != "T"
        return false
      end
    end
    return true
  end

  private def trabajar_proceso(p)
    if p[:estado] == "B"
      siguiente_estado(p)
    elsif p[:instruc].to_i > @quantum
      p[:instruc] = p[:instruc].to_i - @quantum
      p[:estado] = "E"
      reposicionar_cola
      guardar_buffer
      siguiente_estado(p)
    elsif p[:estado] != "T"
      p[:instruc] = 0
      p[:estado] = "E"
      reposicionar_cola
      guardar_buffer
      siguiente_estado(p)
    end
  end

  private def siguiente_estado(p)
    bloqueo = rand(3)
    if bloqueo == 1
      p[:estado] = "B"
    elsif p[:instruc] == 0
      p[:estado] = "T"
    else
      p[:estado] = "L"
    end
  end
end

def main
  puts("Algoritmo de planificación Round Robin
  N(Nuevo) L(Listo) E(Ejecución) B(Bloqueado) T(Terminado)")
  puts("Elija una opción:
  1. Datos fijos
  2. Datos aleatorios
  3. Salir")
  print("» ")
  opcion = gets.to_s.to_i
  if opcion == 1
    print("Cantidad de procesos: ")
    n = gets.to_s.to_i
    print("Valor del quantum: ")
    q = gets.to_s.to_i
    print("Nombre del archivo: ")
    a = gets.to_s.chomp
    RoundRobin.new(n, q, a).fijo
  elsif opcion == 2
    RoundRobin.new(5, 10, "resultados.txt").aleatorio
  elsif opcion == 3
    exit
  else
    error("Opción incorrecta\n\n")
  end
rescue
  error("Entrada incorrecta\n\n")
end

def error(msg)
  print("\e[H\e[2J")
  print(msg)
  main
end

# main

RoundRobin.new(ARGV[0].to_i, ARGV[1].to_i, "crystal.txt").aleatorio
