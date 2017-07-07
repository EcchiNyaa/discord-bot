require 'sequel'
require 'sqlite3'

module Cygnus
  module Cygnus_Commands
    # IMOUTO
    # Um simples mini-game, pode servir de exemplo para novos contribuidores.
    # Possui rankings, countdown, e manipula sqlite utilizando sequel.
    module Imouto
      extend Discordrb::Commands::CommandContainer

      DB = Sequel.connect("sqlite://#{DIR_DB}/imouto.db")

      Sequel.extension :migration
      Sequel::Migrator.run DB, "#{DIR_DB}/migrations/imouto"

      class User
        def initialize
          @users = DB[:users]
        end

        def registered?( discord_id )
          q = @users.where :user => discord_id
          q.first == nil ? false : true
        end

        def register( discord_id )
          @users.insert :user => discord_id
        end

        def created_on( discord_id )
          q = @users.where :user => discord_id
          q.first[:created_on]
        end

        def updated_on( discord_id )
          q = @users.where :user => discord_id
          q.first[:updated_on]
        end

        def imoutos( discord_id )
          q = @users.where :user => discord_id
          q.first[:imoutos]
        end

        def can?( discord_id, hour )
          return true if self.updated_on( discord_id ) == nil

          seconds_passed = Time.now - self.updated_on( discord_id )
          interval = hour * 3600
          seconds_passed > interval ? true : false
        end

        def add_imouto( discord_id, amount )
          q = @users.where( :user => discord_id )
          q.update( :imoutos => Sequel.+( :imoutos, amount ), :updated_on => Sequel::CURRENT_TIMESTAMP )
        end

        def top5
          @users.limit( 5 ).reverse_order :imoutos
        end
      end

      greet = ["Onii-chan", "Onii-sama", "Master", "Nii-san", "Nii-chan", "Nii-nii"]

      command :imouto, description: "[Mini-game] Solicitar imoutos (4 horas)." do |event, arg|
        user = User.new
        user.register event.user.id unless user.registered? event.user.id
        event << "Tente novamente mais tarde, #{greet.sample}." unless user.can? event.user.id, 4
        break unless user.can? event.user.id, 4

        amount = rand( 10 .. 100 )
        user.add_imouto event.user.id, amount

        event << "Você ganhou #{amount} imoutos, #{greet.sample}."
      end

      command :imoutos, description: "[Mini-game] Checar quantidade de imoutos." do |event|
        user = User.new

        discord_id = event.user.id; op = 0
        name = event.user.display_name

        unless event.message.mentions.empty?
          discord_id = event.message.mentions.first.id; op = 1
          name = event.message.mentions.first.on( event.server ).display_name
        end

        sentence = [ [ "Registre-se"], [ "Usuário deve registrar-se" ] ]
        event << "#{sentence[op][0]} com o comando !imouto." unless user.registered? discord_id
        break unless user.registered? discord_id

        achievements = [
          { :id => 0, :rank => "Onii-san Eventual", :required_imoutos => 99, :color => "6B8E23" },
          { :id => 1, :rank => "Onii-san Regular", :required_imoutos => 300, :color => "00FFFF" },
          { :id => 2, :rank => "Onii-san Adorado", :required_imoutos => 900, :color => "FFD700" },
          { :id => 3, :rank => "Master Onii-san", :required_imoutos => 3999, :color => "DF0174" }
        ]

        # Posteriormente irei utilizar a variável 'id', por isso FOR.
        for achievement in achievements do
          id = achievement[:id] if user.imoutos( discord_id ) > achievement[:required_imoutos]
        end

        event.channel.send_embed do |embed|
          embed.title = achievements[id][:rank] + " " + "★"*id
          embed.description = "----------------------------------"
          embed.thumbnail = { url: "https://i.imgur.com/XlYI13r.png" }
          embed.color = achievements[id][:color]
          embed.add_field name: "Usuário", value: name, inline: true
          embed.add_field name: "Imoutos", value: user.imoutos( discord_id ), inline:true
          embed.add_field name: "Iniciou a jogar em", value: user.created_on( discord_id ).strftime( "%d/%m/%Y %H:%M" ), inline: true
          embed.add_field name: "Jogou pela última vez", value: user.updated_on( discord_id ).strftime( "%d/%m/%Y %H:%M" ), inline: true
        end
      end

      command :imouto_top, help_available: false do |event|
        user = User.new
        event << "```"
        event << "IMOUTOS\n"; count = 1
        user.top5.each do |top|
          event << "#{count}º - #{event.server.member( top[:user] ).display_name} possui #{top[:imoutos]} imoutos!"
          count += 1
        end
        event << "```"
      end

    end
  end
end
