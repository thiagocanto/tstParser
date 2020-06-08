# Processador de compra

Parser desenvolvido para receber um pedido de compra por integração e salvar no sistema local, possibilitando a consulta pelo sistema


### Instalando

Para instalar o parser, é necessário fazer a instalação dos pacotes.
Na pasta do projeto, após sua clonagem, rodar a sequência de comandos:

```
bundle install
yarn install
rake db:setup
rake db:migrate
```

### Executar a aplicação

Com esses comandos, o ambiente estará pronto para rodar, executando o comando
```
rails s
```

Após isso, a aplicação estará pronta para receber requisições **POST** com as compras