require "discordrb"
require "yaml"

# Constantes.
# Podem ser acessadas em qualquer parte do código.
DIR      =  File.dirname(__FILE__)
DIR_DB   =  DIR + "/database"
DIR_DATA =  DIR + "/data"
DIR_LOG  =  DIR_DATA + "/logs"
CONFIG   =  YAML.load_file DIR + "/config/config.yml"

Discordrb::LOGGER.streams << File.open( "#{DIR_LOG}/Nyaa.log", "a" )
Discordrb::LOGGER.info "Iniciando Nyaa versão #{`cd #{DIR} && git log -1 --format="%h"`}"

module Cygnus
  # Inclui todos os arquivos do diretório /modules
  # em seu determinado módulo.

  BOT = Discordrb::Commands::CommandBot.new \
    no_permission_message: "Não tenho permissão para fazer isso!",
    token: CONFIG["token"],
    client_id: CONFIG["client_id"],
    prefix: CONFIG["prefix"],
    help_command: false

  # Importa e inclui cada um dos módulos.
  Dir["#{DIR}/modules/*.rb"].each              { |file| require file }
  Dir["#{DIR}/modules/commands/**/*.rb"].each  { |file| require file }
  Dir["#{DIR}/modules/events/*.rb"].each       { |file| require file }

  Cygnus_Commands.constants.each do |command|
    BOT.include! Cygnus_Commands.const_get command
  end

  Cygnus_Events.constants.each do |event|
    BOT.include! Cygnus_Events.const_get event
  end

  BOT.run
end
