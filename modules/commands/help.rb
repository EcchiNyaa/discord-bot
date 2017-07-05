# bot.include! Help
# Sobrescreve o comando !help padrão.

module Help
  extend Discordrb::Commands::CommandContainer

  command :help, help_available: false do |event|
    count = 1
    event << "Comandos disponíveis:"
    event.bot.commands.each do |name, command|
      # Não consegui identificar a causa de um erro (400 Bad Request)
      # que ocorre ao atingir o final do loop, então vou fazer juz ao jeitinho
      # brasileiro e parar antes do loop terminar.
      count += 1
      break if count == event.bot.commands.length - 1
      attributes = command.instance_variable_get('@attributes')

      # Se não houver ajuda disponível.
      next unless attributes[:help_available]
      event << "**!#{name}** -> #{attributes[:description]}"
    end
  end

end
