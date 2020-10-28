# Get Tweets

## Development

Crie as configurações do airflow, lembre-se alterar as chaves de acesso ao twiiter:
```bash
cp resources/config/airflow.env{.sample,}
```

Para inicar o jupyter em dev: `make dev`. Os notebooks contidos em `src/notebooks` serão carregados em `work` no jupyter.

## TODO

Os seguintes pontos ainda estão pendentes:

- Utilizar configuração para a hashtag ao invés de deixa-la fixa
- Utilizar configuração para a data de execução, parâmetro será configurado pelo airflow
- Alterar query do twiter para filtrar por data (é suportado?)
- Dags para data cleaning (falta analizar os dados para esta)
- Testes e execução via airflow

## Considerações

Foi construído um único container com airflow e jupyter para simplificar a execução.
O notebook, assim como as configurações são montadas em runtime.

Para execução em produção o jupyter e airflow seriam containers distintos. Os notebooks poderiam ficar em um repositório (git por exemplo) e serem carregados durante a execução. O uso de operators para kubernates ou yarn podem ser utulizados para execução dos notebooks.

### Testing

Aqui vejo duas estratégias para testes:

- Utilizando o notebook porém com somente um parte dos doados, assim organizando os notebooks, poderiam existir notebooks adicionar para testes;
- Ao invés de utilizar notebooks, converte-los para um projeto scala, assim testes unitarios com o uso de ferramentas como [spark-testing-base](https://github.com/holdenk/spark-testing-base) podem ser realizados.
