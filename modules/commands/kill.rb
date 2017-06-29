# bot.include! Kill
# Shutdown.

module Kill
  extend Discordrb::Commands::CommandContainer

  command :kill, description: "" do |event|
    break unless CONFIG["super_admin"].split( " " ).include? event.user.id.to_s
    event.user.pm "Shutting down."
    exit
  end
end
