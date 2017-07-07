require 'colorize'

module Cygnus
  module Logger
    # CORE - MÓDULO DE LOG
    # Caso a data não seja fornecida, utiliza-se a hora atual.
    class Log
      def initialize( logfile )
        @logfile = logfile
      end

      def info( text, user, type, timestamp = nil )
        timestamp = timestamp.strftime( "%d/%m/%Y %H:%M:%S" ) if timestamp
        timestamp = Time.now.strftime( "%d/%m/%Y %H:%M:%S" ) unless timestamp

        msg = "[ #{type} ] [ #{timestamp} ] [ #{user} ] #{text}\n"

        File.open @logfile, "a" do |log|
          log.write msg
        end

        # Mostra o log no terminal se estiver em modo verbose.
        self.stdout type, msg if CONFIG["verbose"]
      end

      def stdout( type, msg )
        return if type.start_with? "#"

        puts msg.strip.colorize( :color => :black, :background => :light_yellow ) if type == "PM"
        puts msg.strip.colorize( :color => :light_white, :background => :red ) if type == "ADMIN"
        puts msg.strip.colorize( :color => :light_white, :background => :black ) if type == "JOIN / PART"
      end
    end
  end
end
