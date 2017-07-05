require "discordrb"       # Discord API.
require "open3"           # Prevent shell injection.
require "nokogiri"        # HTTP scraping.
require "open-uri"        # HTTP scraping.
require "sqlite3"         # Database.
require "yaml"            # Config Files.
require 'json'            # Parse json files.

# IMPORTANT!
DIR = File.dirname(__FILE__)
DB_DIR = "#{DIR}/database"
DATA_DIR = "#{DIR}/data"
CONFIG = YAML.load_file("#{DIR}/config/config.yml")

module Cygnus
  # Inclui todos os arquivos do diretório /modules
  # em seu determinado módulo.

  module Cygnus_Commands
    Dir["#{DIR}/modules/commands/*.rb"].each { |file| require file }
  end

  module Cygnus_Events
    Dir["#{DIR}/modules/events/*.rb"].each { |file| require file }
  end

  bot = Discordrb::Commands::CommandBot.new token: CONFIG["token"], client_id: CONFIG["client_id"], prefix: CONFIG["prefix"]

  # EVENT.
  bot.include! Cygnus_Events::Version
  bot.include! Cygnus_Events::User_Management

  # COMMAND.
  bot.include! Cygnus_Commands::Administration
  bot.include! Cygnus_Commands::User_Info
  bot.include! Cygnus_Commands::EcchiNyaa
  bot.include! Cygnus_Commands::Japanese
  bot.include! Cygnus_Commands::Help

  bot.run
end
