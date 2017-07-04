# bot.include! Version
# Shows the git commit hash.

module Version
  extend Discordrb::EventContainer

  mention do |event|
    event << "Running \"EcchiNyaa\" #{`cd #{DIR} && git log -1 --format="%h (%ar)"`.strip}."
  end
end
