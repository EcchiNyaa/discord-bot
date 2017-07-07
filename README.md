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

* Database sincronizada, sem necessidade de acessar o server do EcchiNyaa a cada requisição.
* API em PHP/json construída para ligar o bot ao website.

### Canal de administração

![Screenshot Administração](/data/screenshot/screenshot_admin.png?raw=true)

* Fornece logs sobre usuários.
* Mantêm sugestões e pedidos em canal privado.
* Função básica de tickets.

## Modo verbose

![Screenshot Verbose](/data/screenshot/screenshot_verbose.png?raw=true)

* Exibe informações enviadas ao log no terminal, coloridas para melhor identificação.

## Contribuição

Note que Nyaa ainda está em processo de desenvolvimento.

Pull requests são bem aceitos, fique à vontade para revisar o código ou adicionar novas funções.
