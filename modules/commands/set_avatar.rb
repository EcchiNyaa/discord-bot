# bot.include! Set_Avatar
# Set the bot's avatar.

module Set_Avatar
  extend Discordrb::Commands::CommandContainer

  command :bot_avatar, help_available: false do |event, img|
    break unless CONFIG["super_admin"].split( " " ).include? event.user.id.to_s

    event.bot.profile.avatar = open( img )
    event.user.pm "Done."
  end
end
