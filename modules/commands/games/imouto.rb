require "sequel"
require "sqlite3"

module Cygnus
  module Cygnus_Commands
    # IMOUTO
    # Um simples mini-game, pode servir de exemplo para novos contribuidores.
    # Possui rankings, countdown, e manipula sqlite utilizando sequel.
    module Imouto
      extend Discordrb::Commands::CommandContainer

      greet = ["Onii-chan", "Onii-sama", "Master", "Nii-san", "Nii-chan", "Nii-nii"]

      command :imouto, description: "[Mini-game] Solicitar imoutos (4 horas)." do |event, arg|
        user = Cygnus::Database::ImoutoUser.where( user: event.user.id ).first
        user = Cygnus::Database::ImoutoUser.create( user: event.user.id ) if user.nil?

        amount = rand( 10..100 )
        user.imoutos += amount
        user.save ? "Você ganhou #{amount} imoutos, #{greet.sample}!" : "Tente novamente mais tarde, #{greet.sample}."
      end

      command :imoutos, description: "[Mini-game] Checar quantidade de imoutos." do |event|
        event.message.mentions.empty? ? e = event.user : e = event.message.mentions.first
        user = Cygnus::Database::ImoutoUser.where( user: e.id ).first
        next "Usuário não registrado, insira !imouto." if user.nil?

        achievements = [
          { id: 0, rank: "Onii-san Eventual", required_imoutos: 0, color: "6B8E23" },
          { id: 1, rank: "Onii-san Regular", required_imoutos: 300, color: "00FFFF" },
          { id: 2, rank: "Onii-san Adorado", required_imoutos: 900, color: "FFD700" },
          { id: 3, rank: "Master Onii-san", required_imoutos: 3999, color: "DF0174" }
        ]

        for achievement in achievements do
          id = achievement[:id] if user.imoutos >= achievement[:required_imoutos]
        end

        event.channel.send_embed do |embed|
          embed.title = achievements[id][:rank] + " " + "★"*id
          embed.description = "----------------------------------"
          embed.thumbnail = { url: "https://i.imgur.com/XlYI13r.png" }
          embed.color = achievements[id][:color]
          embed.add_field name: "Usuário", value: e.display_name, inline: true
          embed.add_field name: "Imoutos", value: user.imoutos, inline:true
          embed.add_field name: "Iniciou a jogar em", value: user.created_on.strftime( "%d/%m/%Y %H:%M" ), inline: true
          embed.add_field name: "Jogou pela última vez", value: user.updated_on.strftime( "%d/%m/%Y %H:%M" ), inline: true
        end
      end

      command :imouto_top, help_available: false do |event|
        top5 = Cygnus::Database::ImoutoUser.limit( 5 ).reverse_order :imoutos

        event << "```"
        event << "IMOUTOS\n"; count = 0
        top5.each do |top|
          count += 1
          "#{count}º - #{event.server.member( top[:user] ).display_name} possui #{top[:imoutos]} imoutos!"
        end
        event << "```"
      end

    end
  end
end
