# [E-commerce de Produtos]

##Descrição
[Aplicação de banco de dados que simula um sistema de e-commerce, contendo cadastro de produtos, clientes, endereços, pedidos, avaliações e relacionamento entre essas entidades. O objetivo é permitir consultas, inserções e gerenciamento básico de uma loja virtual.]

##Autores

-[Estevão Martins De Faria]

-[Dominique Gomes Barbosa]

-[Júllia Paranhos de Moraes]

##Tecnologias Utilizadas
-MySQL
-Docker
-MySQL Workbench


##Modelo de Dados
-Dados Lógicos

##Entidades Principais

-[produtos]: Armazena informações de cada produto vendido, como nome, preço, marca, categoria e estoque.

-[cep]: Representa endereços, contendo rua, bairro, município, estado e número da casa.

-[clientes]: Contém dados dos clientes, incluindo nome, e-mail, senha e referência ao endereço (tabela cep).

-[pedidos]: Registra cada pedido feito pelos clientes, incluindo status e qual cliente realizou a compra.

-[pedidos_produtos]: Tabela associativa que liga produtos a pedidos, indicando quais itens foram comprados e em qual quantidade.

-[avaliacoes]: Guarda avaliações feitas pelos clientes sobre produtos, incluindo estrelas e comentários.

-[Views (clientes_compras, clientes_avaliacoes, produtos_baratos, regiao_cliente)]: Consultas pré-definidas para facilitar análise de dados.


####Relacionamentos

-clientes → cep
-Relacionamento: Um-para-Um
-Descrição: Cada cliente possui um endereço (id_cep), e um endereço pode ser usado por um cliente

-pedidos → clientes
-Relacionamento: Muitos-para-Um
-Descrição: Cada pedido pertence a um cliente, mas um cliente pode ter vários pedidos.

-pedidos_produtos → pedidos / produtos
-Relacionamento: Muitos-para-Muitos
-Descrição: Um pedido pode conter vários produtos, e um produto pode aparecer em vários pedidos.
-A tabela pedidos_produtos resolve esse relacionamento.

-avaliacoes → clientes / produtos
-Relacionamento: Muitos-para-Um
-Descrição: Um cliente pode fazer várias avaliações e um produto pode receber várias avaliações.


##Decisões de Design

-Normalização:
-O banco segue o padrão de tabelas separadas para entidades distintas, reduzindo redundância.
-A tabela de associação pedidos_produtos normaliza o relacionamento muitos-para-muitos.

-Índices criados:
-Foram criados índices para melhorar performance em consultas frequentes:

-categoria, id_produto e preco na tabela produtos.

-email na tabela clientes.

-id_cliente na tabela pedidos.


-CHECK constraints:
-Utilizados para garantir integridade lógica, como estoque ≥ 0 e estrelas entre 0 e 10.

-Views:
-Criadas para facilitar consultas comuns, como listagem de pedidos com seus clientes, avaliações por cliente ou produtos baratos.

-Chaves estrangeiras:
-Utilizadas para garantir integridade referencial entre todas as tabelas relacionadas (cliente–CEP, pedidos–clientes, avaliações–produtos etc.).
