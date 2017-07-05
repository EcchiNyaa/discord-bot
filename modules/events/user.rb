module Cygnus
  module Cygnus_Events
    # bot.include! User_Info
    # Caso ativo, mostra no canal da administração informações sobre os membros.
    module User_Management
      extend Discordrb::EventContainer

      member_join do |event|
        event.bot.channel( CONFIG["admin_channel_id"] ).send_message \
        "[ Cadastrado em: #{event.user.creation_time.strftime( "%d/%m/%Y" )} ] #{event.user.mention} entrou."
      end

      member_leave do |event|
        event.bot.channel( CONFIG["admin_channel_id"] ).send_message "#{event.user.mention} (#{event.user.distinct}) saiu."
      end
    end
  end
end
