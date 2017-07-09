module Cygnus
  module Cygnus_Events
    # MÓDULO DE LOG
    # Guarda PM e mensagens enviadas, depende de /config/config.yml.
    module Discord_Logger
      extend Discordrb::EventContainer

      message private: false do |event|
        next unless CONFIG["log_server_messages"]

        user = event.message.author
        time = event.message.timestamp.strftime( "%d/%m/%Y %H:%M:%S" )
        message = event.message.content
        message = "⤷ ANEXO NÃO DISPONÍVEL" unless event.message.attachments.empty?
        channel = event.message.channel.name

        File.open "#{DIR_LOG}/txt/##{channel}.txt", "a" do |log|
          log.write "#{time} | #{user.distinct} (#{user.id}) :: #{message}\n"
        end
      end

      private_message do |event|
        break unless CONFIG["log_private_messages"]

        user = event.message.author
        time = event.message.timestamp.strftime( "%d/%m/%Y %H:%M:%S" )
        message = event.message.content

        File.open "#{DIR_LOG}/PM.log", "a" do |log|
          log.write "#{time} | #{user.distinct} (#{user.id}) :: #{message}\n"
        end
      end
    end
  end
end
