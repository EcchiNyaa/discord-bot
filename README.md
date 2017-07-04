# EcchiNyaa Bot ( Alpha )

1. Faça uma cópia do arquivo `config/config-default.yml` para `config/config.yml`.
2. Certifique-se de que os módulos estão incluídos em `nyaa.db`.
3. Execute `bundler` no diretório para instalar as dependências.
4. Para iniciar o bot, basta executar `ruby nyaa.rb`.

## Planos

- [ ] Otimizar comando !help
- [ ] Implementar um módulo de logs.
- [ ] Implementar modo daemon + systemd.

## Japonês

```
[17:02] mitki: @EcchiNyaa
[17:02] EcchiNyaa: Running "EcchiNyaa" 7b3a0c9 (48 seconds ago).
[17:03] mitki: !katakana ecchinyaa
[17:03] EcchiNyaa: エッチニャア
[17:07] mitki: !romaji 俺は人の流れから外れ
[17:07] EcchiNyaa: [JAP] ore ha hito no nagare kara hazure
```

![Screenshot Japonês](https://github.com/EcchiNyaa/discord-bot/blob/master/data/screenshot/screenshot%20jp.png?raw=true)

## Integração com o EcchiNyaa

![Screenshot Animes](https://github.com/EcchiNyaa/discord-bot/blob/master/data/screenshot/screenshot%20anime.png?raw=true)

![Screenshot Ecchis](https://github.com/EcchiNyaa/discord-bot/blob/master/data/screenshot/screenshot%20ecchi.png?raw=true)

Database sincronizada, sem necessidade de acessar o server do EcchiNyaa a cada requisição.
