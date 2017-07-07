# Nyaa Bot

1. Faça uma cópia do arquivo `config/config-default.yml` para `config/config.yml`.
2. Preencha todos os campos de `config/config.yml`.
3. Execute `bundler` no diretório para instalar as dependências.
4. Para iniciar o bot, basta executar `./start`.

## Planos

- [x] Otimizar comando !help
- [x] Implementar um módulo de logs.
- [ ] Implementar modo daemon + systemd.

## Descrição

Nyaa é um bot modular construido com discordrb -- implementação em ruby da API do Discord -- totalmente integrado com o EcchiNyaa, com funções de pesquisa, administração e tickets. Outras dezenas de recursos estão incluídos, em destaque o módulo da língua japonesa.

Devido sua natureza modular, Nyaa é facilmente extensível. Depois de programar um comando só é preciso movê-lo para `/modules/commands` e reiniciar o bot.

## Funções

Quer sugerir uma função? Crie uma `issue`.

### Língua Japonesa

```
[17:02] mitki: @EcchiNyaa
[17:02] EcchiNyaa: Running "EcchiNyaa" 7b3a0c9 (48 seconds ago).
[17:03] mitki: !katakana ecchinyaa
[17:03] EcchiNyaa: エッチニャア
[17:07] mitki: !romaji 俺は人の流れから外れ
[17:07] EcchiNyaa: [JAP] ore ha hito no nagare kara hazure
```

![Screenshot Japonês](/data/screenshot/screenshot_jp.png?raw=true)

![Screenshot Japonês 2](/data/screenshot/screenshot_jp2.png?raw=true)

### Integração com o EcchiNyaa

![Screenshot Animes](/data/screenshot/screenshot_anime.png?raw=true)

![Screenshot Ecchis](/data/screenshot/screenshot_ecchi.png?raw=true)

Construiu-se uma API em PHP/json para ligar o bot ao website. Nyaa faz consultas regularmente e atualiza uma database mantida localmente, de forma que não tenha necessidade de acessar o server do EcchiNyaa a cada requisição.

### Canal de administração

![Screenshot Administração](/data/screenshot/screenshot_admin.png?raw=true)

Suporta um canal privado de administração com sistema básico de tickets, usuários podem fazer sugestões e pedidos através de comandos, que são dispostos de forma organizada para a administração e podem ser marcados como 'Resolvidos' ou 'Em espera'.

## Modo verbose

![Screenshot Verbose](/data/screenshot/screenshot_verbose.png?raw=true)

Exibe informações coloridas no terminal, caso `verbose` true.

## Logs

![Screenshot Logs](/data/screenshot/screenshot_logs.png?raw=true)

Mantêm logs de administração em database ou arquivo txt. Em `config.yml` é possível ativar o log de mensagens em todos os canais, que por padrão é desativado por ser desnecessário.

## Contribuição

Note que Nyaa ainda está em processo de desenvolvimento.

Pull requests são bem aceitos, fique à vontade para revisar o código ou adicionar novas funções.
