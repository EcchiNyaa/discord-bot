# bot.include! User_Info
# Log users.

module User_Info
  extend Discordrb::EventContainer

  member_join do |event|
    event.bot.channel( CONFIG["admin_channel_id"] ).send_message "#{event.user.name} joined."
  end

  member_leave do |event|
    event.bot.channel( CONFIG["admin_channel_id"] ).send_message "#{event.user.name} quit."
  end
end
