module Cygnus
  module Cygnus_Events
    # bot.include! Version
    # Mostra a versão do bot, o diretório deve ser um repositório git.
    module Version
      extend Discordrb::EventContainer

      mention do |event|
        event << "Running \"EcchiNyaa\" #{`cd #{DIR} && git log -1 --format="%h (%ar)"`.strip}."
      end
    end
  end
end
