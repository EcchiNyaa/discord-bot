module Cygnus
  module Cygnus_Events
    # MÓDULO DE VERSÃO
    # Exibe a versão do repositório local.
    module Version
      extend Discordrb::EventContainer

      mention do |event|
        event << "Running \"EcchiNyaa\" #{`cd #{DIR} && git log -1 --format="%h (%ar)"`.strip}."
      end
    end
  end
end
