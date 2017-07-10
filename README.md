# Nyaa Bot

1. Faça uma cópia do arquivo `config/config-default.yml` para `config/config.yml`.
2. Preencha todos os campos de `config/config.yml`.
3. Execute `bundler` no diretório para instalar as dependências.
4. Para iniciar o bot, basta executar `./start`.

## Planos

- [x] Otimizar comando !help
- [x] Implementar um módulo de logs.
- [ ] Reimplementar busca de eroges (revertida).
- [ ] Implementar modo daemon + systemd.

Nyaa será considerado estável ao cumprir as metas acima.

- [ ] Integração com outras plataformas, como MAL e VNDB.
- [ ] Incluir busca por personagens e staff.
- [ ] Fansub feed: Nyaa pode avisar por PM quando determinado fansub efetuar determinado lançamento.

## Descrição

Nyaa é um bot modular construido com discordrb -- implementação em ruby da API do Discord -- totalmente integrado com o EcchiNyaa, com funções de pesquisa, administração e tickets. Outras dezenas de recursos estão incluídos, em destaque o módulo da língua japonesa.

Devido sua natureza modular, Nyaa é facilmente extensível. Depois de programar um comando só é preciso movê-lo para `/modules/commands` e reiniciar o bot.

## Funções

Quer sugerir uma função? Crie uma `issue`.

### Língua Japonesa

- `!jp [palavra] [opcional: 1-10]` - Mostra a tradução de certa palavra japonesa.
- `!hiragana [frase]` - Converte a frase para hiragana.
- `!katakana [frase]` - Converte a frase para katakana.
- `!romaji [frase]` - Faz uma boa estimativa da frase em romaji.

```
[17:03] mitki: !katakana EcchiNyaa
[17:03] EcchiNyaa: エッチニャア
```

![Screenshot Japonês](/data/screenshot/screenshot_jp.png?raw=true)

![Screenshot Japonês 2](/data/screenshot/screenshot_jp2.png?raw=true)

### Integração com o EcchiNyaa

- `!anime [nome]` - Busca por animes no catálogo do EcchiNyaa.
- `!ecchi [nome]` - Busca por ecchis no catálogo do EcchiNyaa.
- `!anime.atualizar` (ADMIN) - Sincroniza a DB manualmente.
- `!ecchi.atualizar` (ADMIN) - Sincroniza a DB manualmente.

Busca por eroges revertida temporariamente, será reescrita para utilizar também informações do VNDB.

![Screenshot Animes](/data/screenshot/screenshot_anime.png?raw=true)

![Screenshot Ecchis](/data/screenshot/screenshot_ecchi.png?raw=true)

Construiu-se uma API em PHP/json para ligar o bot ao website. Nyaa faz consultas regularmente e atualiza uma database mantida localmente, de forma que não tenha necessidade de acessar o server do EcchiNyaa a cada requisição.

### Módulo administrativo.

- `!reportar [issue]` - Abre um ticket e o envia a moderação.
- `!tickets` (ADMIN) - Lista os últimos 10 tickets pendentes.
- `!ticket #2` (ADMIN) - Mostra o ticket #2.
- `!ticket #2 fechar` (ADMIN) - Fecha o ticket #2.
- `!ticket #2 abrir` (ADMIN) - Reabre o ticket #2.
- `!ticket.del [usuário]` (ADMIN) - Remove todos os tickets do usuário.


- `!rm [2-100]` (ADMIN) - Deleta certo número de mensagens.
- `!prune [2-100] [usuário]` (ADMIN) - Deleta mensagens do usuário presentes no range.
- `!retroceder [id da mensagem]` (ADMIN) - Apaga todas as mensagens até certo ID.


- `!role [usuário]` (ADMIN) - Adiciona o usuário a certo cargo.
- `!kick [usuário] [razão]` (ADMIN) - Expulsa o usuário do servidor.
- `!ban [usuário] [razão]` (ADMIN) - Usuário será banido.


- `!bot.kill` (SUPER ADMIN) - Desliga o bot.
- `!bot.avatar [url]` (SUPER ADMIN) - Altera o avatar do bot.

![Screenshot Administração](/data/screenshot/screenshot_admin1.png?raw=true)

![Screenshot Administração](/data/screenshot/screenshot_admin2.png?raw=true)

Suporta um canal privado de administração com sistema básico de tickets, usuários podem fazer sugestões e pedidos através de comandos, que são dispostos de forma organizada para a administração e podem ser marcados como resolvidos.

![Screenshot Transparência](/data/screenshot/screenshot_transparencia.png?raw=true)

Inspirado em alguns servidores, é possível exibir as operações da moderação em um canal (por exemplo, #transparencia).

### Utilidades gerais

- `!info [opcional: usuário]` - Mostra informações sobre o usuário.
- `!ping` - Exibe o ping em milissegundos.
- `!help` - Comando de ajuda, não exibe opções administrativas.

![Screenshot Transparência](/data/screenshot/screenshot_info.png?raw=true)

### Logs

Mantêm logs administrativos organizados em uma database, e mensagens privadas são mantidas em um arquivo de texto. Log global (i.e. de todos os canais) é desativado por padrão, mas pode ser ativado editando `config.yml`.

## Contribuição

Note que Nyaa ainda está em processo de desenvolvimento.

Pull requests são bem aceitos, fique à vontade para revisar o código ou adicionar novas funções.
