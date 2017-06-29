# bot.include! Version
# Shows the git commit hash.

module Version
  extend Discordrb::Commands::CommandContainer

  command :info, description: "Show the commit hash and the last updated date." do |event|
    event << "<https://github.com/EcchiNyaa/discord-bot>"
    event << "Commit: #{`cd #{DIR} && git log -1 --format="%H (%ar)"`.strip}."
  end
end
