require "discordrb"       # Discord API.
require "yaml"            # Config Files.

# GLOBAL CONSTANTS.
DIR      =  File.dirname(__FILE__)
DIR_DB   =  DIR+"/database"
DIR_DATA =  DIR+"/data"
DIR_LOG  =  DIR_DATA+"/logs"
CONFIG   =  YAML.load_file DIR+"/config/config.yml"

module Cygnus
  # Inclui todos os arquivos do diretório /modules
  # em seu determinado módulo.

  bot = Discordrb::Commands::CommandBot.new token: CONFIG["token"], client_id: CONFIG["client_id"], prefix: CONFIG["prefix"]

  # Importa os módulos e inclui cada constante.
  Dir["#{DIR}/modules/*.rb"].each              { |file| require file }
  Dir["#{DIR}/modules/commands/**/*.rb"].each  { |file| require file }
  Dir["#{DIR}/modules/events/*.rb"].each       { |file| require file }

  Cygnus_Commands.constants.each do |command|
    bot.include! Cygnus_Commands.const_get command
  end

  Cygnus_Events.constants.each do |event|
    bot.include! Cygnus_Events.const_get event
  end

  bot.run
end
