require "discordrb"
require "yaml"
require "pry"

CONFIG = YAML.load_file("config/config.yml")

module Nyaa
  BOT = Discordrb::Commands::CommandBot.new(
    token:     CONFIG["token"],
    client_id: CONFIG["client_id"],
    prefix:    CONFIG["prefix"],
    no_permission_message: "Não tenho permissão suficiente.",
    help_command: false
  )

  Dir["modules/*.rb"].each              { |file| load file }
  Dir["modules/commands/**/*.rb"].each  { |file| load file }
  Dir["modules/events/*.rb"].each       { |file| load file }

  Commands.constants.each do |command|
    BOT.include! Commands.const_get command
  end

  Events.constants.each do |event|
    BOT.include! Events.const_get event
  end

  BOT.run :async

  binding.pry

  BOT.sync
end
