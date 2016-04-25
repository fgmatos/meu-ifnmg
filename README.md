# meu IFNMG

####### Portal para aprensentação de dados abertos sobre do IFNMG.
---

Baixe os fontes do projeto e instale as gem's:
> bundle install

Crie o banco:
> rake db:migrate
 
Inicie o servidor (utilize a opção '-p' para informar a porta desejada, por default é porta 3000)
> rails s 

O portal meuIFNMG aprensenta dados abertos sobre diarias e servidores do Instituto Federal de Educação, Ciência e Tecnologia do Norte de Minas Gerias.
Todos os dados foram obtidos em "http://www.transparencia.gov.br/downloads/" e armazenados no sistema em:

> '/app/data/'

As informações sobre diarias devem ser colocadas em 'app/data/diarias'. Estamos trabalhando com dados de 2011 à 2015
onde o script de importacao irar ler os arquivos '.CSV' de encontrados no diretorio citado e que tenham o nome no
seguinte formato: 'YYYYMM_Diarias.csv'.

Devido ao limite de armazenamento do github (100MB por arquivo) os dados sobre servidores não estão no repositório. Você
pode baixo-los em "http://www.transparencia.gov.br/downloads/servidores.asp#exercicios2015". 
Os arquivos deverão ser extraidos no diretório '/app/data/servidores'.

Realize a importação dos dados de 2012 à 2016. salve e extraia os arquivos na pasta 'app/data/servidores'.

Realize a importação dos dados citados para o portal utlilize o comando:
> rake db:seed

Será solicitado que escolha quais dados deseja realizar a importação, lembrando que caso deseje personalizar
as taregas de importação edite o arquivo 'db/seeds.rb'.

acesse o site. (endereço default -> http://localhost:3000)
> http://[seu-ip-servidor]:[porta]

Para mais informações registre uma issue.

Thank you! =)

Equipe:
fgm, fgm2, nbcj2, rlcsf
