module Cygnus
  module Cygnus_Events
    # MÓDULO DE LOG
    # Guarda PM e mensagens enviadas, depende de /config/config.yml.
    module Discord_Logger
      extend Discordrb::EventContainer

      message private: false do |event|
        next unless CONFIG["log_server_messages_to_file"]

        user = event.message.author.distinct
        time = event.message.timestamp
        message = event.message.content
        message = "⤷ ANEXO NÃO DISPONÍVEL" unless event.message.attachments.empty?
        channel = event.message.channel.name

        log = Cygnus::Logger::Log.new "#{DIR_LOG}/txt/##{channel}.txt"
        log.info message, user, "#"+channel, time
      end

      private_message do |event|
        break unless CONFIG["log_private_messages"]

        user = event.message.author.distinct
        time = event.message.timestamp
        message = event.message.content

        log = Cygnus::Logger::Log.new "#{DIR_LOG}/txt/PM.txt"
        log.info message, user, "PM", time
      end
    end
  end
end
