module Cygnus
  module Cygnus_Events
    # MÓDULO DE JOIN / PART
    # Anuncia no canal definido em config.yml o fluxo de entrada e saida do servidor..
    module Join_Part
      extend Discordrb::EventContainer

      member_join do |event|
        log = Cygnus::Logger::Log.new "#{DIR_LOG}/Join.log"
        log.info ">> Entrou no servidor, ID '#{event.user.id}'.", event.user.distinct, "JOIN / PART"

        event.bot.channel( CONFIG["joined_event_channel_id"] ).send_message \
        "[ Cadastrado em: #{event.user.creation_time.strftime( "%d/%m/%Y" )} ] #{event.user.mention} entrou."
      end

      member_leave do |event|
        log = Cygnus::Logger::Log.new "#{DIR_LOG}/Part.log"
        log.info "<< Saiu do servidor, ID '#{event.user.id}'.", event.user.distinct, "JOIN / PART"

        event.bot.channel( CONFIG["joined_event_channel_id"] ).send_message \
        "#{event.user.mention} (#{event.user.distinct}) saiu."
      end
    end
  end
end
