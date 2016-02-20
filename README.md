# meu IFNMG

####### Portal para aprensentação de dados abertos sobre do IFNMG.
---

Baixe os fontes do projeto e instale as gem's:
> bundle install

Crie o banco:
> rake db:migrate

Inicie o servidor (utilize a opção '-p' para informar a porta desejada, por default é porta 3000)
> rails s 

O portal meuIFNMG aprensenta dados sobre diarias e servidores do Instituto Federal de Educação, Ciência e Tecnologia do Norte de Minas Gerias.
Todos os dados foram obtidos em "http://www.transparencia.gov.br/downloads/" e armazenados no sistema em:

> '/app/data/

As informações sobre diarias devem ser colocadas em 'app/data/diarias'. Estamos trabalhando com dados de 2011 à 2015
onde o script de importacao irar ler os arquivos '.CSV' de encontrados no diretorio citado e que tenham o nome no
seguinte formato: 'YYYYMM_Diarias.csv'.

Devido ao limite de armazenamento do github (100MB por arquivo) os dados sobre servidores não estão no repositório. Você
pode baixo-los em "http://www.transparencia.gov.br/downloads/servidores.asp#exercicios2015". 
Os arquivos deverão ser extraidos no diretório '/app/data/servidores'.

Ocorream vários erros na lietura dos arquivos por conterem caracteres inválidos, assim foi realizada a importação de 
servidores de JAN/2015 e DEZ/2015.

Serão importadas as informações sobre pessoal contidas nos arquivos com o nome no formato: 'YYYYMM31_Cadastro.csv'. Durante a extração será
criada uma pasta para cada arquivo '.zip'. Mova os arquivos de cadastro para o diretorio '/app/data/servidores'. 


Realize a importação dos dados citados para o portal utlilize o comando:
> rake db:seed

acesse o site (se mudou a porta alterar aqui)
> http://localhost:3000

se estiver instalado em outra máquina informe o IP
> http://[ip-servidor]:[porta]

Para mais informações registre uma issue.

Thank you! =)

Equipe:
fgm, fgm2, nbcj2, rlcsf
