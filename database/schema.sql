-- =============================================
-- Projeto: [E-commerce de Produtos]
-- Descrição: [Aplicação de banco de dados que simula um sistema de e-commerce, contendo cadastro de produtos, clientes, endereços, pedidos, avaliações e relacionamento entre essas entidades. O objetivo é permitir consultas, inserções e gerenciamento básico de uma loja virtual.]
-- Autores: [Estevão Martins De Faria, Dominique Gomes barbosa e Júllia Paranhos de Moraes]
-- Data: [02/12/2025]
-- =============================================
-- antes de comecar, caso seja a priemira vez que voce abra esse codigo em seu computador, execute essas duas linhas de comando a baixo, caso contrario, nem um codigo funcionarar
CREATE DATABASE IF NOT EXISTS loja; -- criar a database (se ela nao existir)
USE loja; -- usar a database que voce acabou de criar ou que uma ja exista

CREATE TABLE IF NOT EXISTS produtos( -- criar uma tabela caso ela nao exista com o nome 'produtos'
	id_produto INT AUTO_INCREMENT PRIMARY KEY, -- coluna com o nome 'id_produto' com definiçoes que ela é uma INT = apenas numeros inteiros, AUTO_INCREMENT = nao precisa adicionar uma informação ja que ela se auto preenche e PRIMARY KEY = chave primaria (Nao pode se repitir e nao pode ter um valor nulo)
    produto VARCHAR(100) NOT NULL, -- VARCHAR(100) siginifica que é tipo texto com limite maximo de 100 caracteres, NOT NULL = nao pode ser um valor nulo ou seja nao pode estar vazia
    preco DECIMAL(10,2) NOT NULL, -- DECIMAL = numeros decimais com limite de 10 caracteres antes da virgula e 2 depois da virgula 'xxxxxxxxxx,xx'
    marca VARCHAR(75) NOT NULL,
    categoria VARCHAR(45) NOT NULL,
    estoque INT NOT NULL CHECK (estoque >= 0) -- verificar se o valor recebido na coluna é igual ou maior que zero, case seja, passa, caso nao, é bloqueado
    );
    CREATE INDEX idx_categoria ON produtos(categoria); -- cria um indice na coluna, economizando tempo na hora do SELECT, ja que o computador sabe onde esta cada item
    CREATE INDEX idx_id_produto ON produtos(id_produto);
    CREATE INDEX idx_preco ON produtos(preco);
   
    DESCRIBE produtos; -- verificar se a tabela foi criada com todos as atribuicoes e colunas corretas

CREATE TABLE IF NOT EXISTS cep(
	id_cep INT AUTO_INCREMENT PRIMARY KEY,
    numero_casa INT NOT NULL,
    rua VARCHAR(100) NOT NULL,
    bairro VARCHAR(100) NOT NULL,
    municipio VARCHAR(100) NOT NULL,
    estado VARCHAR(100) NOT NULL
    );
    DESCRIBE cep;

CREATE TABLE IF NOT EXISTS clientes(
	id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE, -- UNIQUE = O valor não pode se repitir
    senha VARCHAR(255) NOT NULL, -- Campo para senha do cliente. ATENÇÂO: em um banco de dados real, armazenar usando hash seguro (ex: bcrypt).
    -- NUNCA usar senhas em texto puro por questões de segurança.
    endereco INT UNIQUE,
    FOREIGN KEY (endereco) REFERENCES cep(id_cep) -- Chave estrangeira, a coluna 'endereco' tem que ter um valor ja existente na culuna 'id_cep' da tabela 'cep'
    -- Voce tem que criar a tabela referencial antes de da a Chaves estrangeira em alguma coluna, se nao, vai dar erro de "a coluna 'id_cep' e a tabela 'cep' não existem"
    );
    CREATE INDEX idx_email ON clientes(email);
    DESCRIBE clientes;

CREATE TABLE IF NOT EXISTS pedidos(
	id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'pendente',-- DEFAULT 'pendente' = caso na hora de colocar as informaçoes na tabela não coloque nada em 'status' ele ira vir com 'pendente' por padrão 
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
    );
    CREATE INDEX idx_pedidos_idcliente ON pedidos(id_cliente);
    DESCRIBE pedidos;

CREATE TABLE IF NOT EXISTS pedidos_produtos(
	id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_pedido, id_produto),
	FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
	);
    
CREATE TABLE IF NOT EXISTS avaliacoes(
	id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    data_comentario DATE NOT NULL,
    id_cliente INT NOT NULL,
    id_produto INT NOT NULL,
    estrelas INT NOT NULL CHECK (estrelas BETWEEN 0 AND 10), -- '(estrelas BETWEEN 0 AND 10)' o valor de 'estrelas' deve ser igual ou maior que 0 e menor ou igual a 10
    comentario VARCHAR(1000) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
    );
    DESCRIBE avaliacoes;

    
INSERT INTO produtos (produto, preco, marca, categoria, estoque)VALUES
('Rx580', 599.99, 'AMD', 'eletronico', 14),
('Rtx4090', 24999.99, 'Nvidia', 'eletronico', 4),
('Iphone 17 Pro Max', 1899.99, 'Apple', 'eletronico', 12),
('Galaxy S25 Ultra', 5980.00, 'Samsung', 'eletronico', 11),
('Geladeira Electrolux',1999.90, 'Electrolux', 'eletrodomestico', 4),
('Airfryer',449.99, 'Electrolux', 'eletrodomestico', 9),
('Escova de Dentes',9.90, 'Oral-b', 'Higiene Pessoal', 33),
('Jogo de Facas de Cozinha',99.99, 'Tramontina', 'Cozinha', 23),
('Sabonete',8.90, 'Natura', 'Higiene Pessoal', 55),
('Gtx 1050ti', 899.99, 'Nvidia', 'eletronico', 19);
SELECT * FROM produtos;
SELECT * FROM produtos WHERE id_produto = 2;
SELECT * FROM produtos WHERE produto LIKE '%4090%';
SELECT * FROM produtos WHERE preco < 1000 AND marca = 'Nvidia';
SELECT * FROM produtos ORDER BY preco ASC;
SELECT * FROM produtos ORDER BY preco DESC;
-- injeção de valores
INSERT INTO cep (numero_casa, rua, bairro, municipio, estado)VALUES -- os valores tem que ser colocados na ordem que voce colocou as colunas
(182, 'Geraldo Cardoso', 'Xerem', 'Duque de Caxias', 'Rio de Janeiro'), -- valores decimais ou int sao colocados sem aspas, valores varchar sao colocados com aspas
(855,'Osmar de Andrade','Xerem','Duque de Caxias','Rio de Janeiro'),-- separar com virgula cada valor de cada coluna
(3,'Palinha do Bardo','Santa cruz','Duque de Caxias','Rio de Janeiro'),
(1023,'muito perigo','Vai quem quer','Duque de Caxias','Rio de Janeiro'),
(434,'Rua dos Fartos','Aviario','Petrópolis','Rio de Janeiro'),
(67,'Rua do Morteiro','Amapá','Belford Roxo','Rio de Janeiro'),
(340,'Avenida da Liberdade','Liberdade','São Paulo','São Paulo');
SELECT * FROM cep; -- seleciona todos de cep, * = todos
SELECT * FROM cep WHERE estado = 'Rio de Janeiro'; -- seleciona todos de cep apenas quando o estado é igual a 'rio de janeiro'

INSERT INTO clientes (nome, email, senha, endereco)VALUES
('Estevão Martins','estevaoM@gmail.com','senha123', 1),
('Júllia Paranhos','juparan@gmail.com','29112025', 2),
('Kaua Amado', 'ksamado@hotmail.com', 'amolinux', 3),
('Dominique Gomes', 'nique23@gmail.com','flamengo10', 4),
('Vitor Hugo', 'vitin@gmail.com', 'Barbeador333', 5),
('Andrew Quaresma', 'moryx@gmail.com','xbesta123', 6),
('Moises Henrique', 'mois3s@gmail.com', 'chmod777', 7);
SELECT * FROM clientes;
SELECT * FROM clientes WHERE nome LIKE '%Kaua%'; -- seleciona todos de cleintes quando alguma parte do nome de alguem tiver uma parte da palavra digitada entre %...%
SELECT * FROM clientes WHERE email = 'mois3s@gmail.com';

INSERT INTO pedidos (id_cliente, status)VALUES
(1,'pagamento pendente'),
(3,'pedido entregue'),
(6,'pedido barrado'),
(4,'pedido entregue'),
(7,'pedido enviado'),
(5,'pagamento negado'),
(2,'pedido entregue');
SELECT * FROM pedidos;
SELECT * FROM pedidos WHERE status = 'pedido entregue';

INSERT INTO pedidos_produtos (id_pedido, id_produto, quantidade) VALUES
(1, 4, 1),
(2, 2, 1),
(3, 6, 2),
(4, 8, 1),
(5, 1, 1),
(6, 1, 1),
(7, 3, 1);
SELECT * FROM pedidos_produtos;
SELECT * FROM pedidos_produtos WHERE quantidade > 1; -- imprime todas as colunas de pedidos_produtos que a quantidade forem maiores que 1 


INSERT INTO avaliacoes (data_comentario, id_cliente, id_produto, estrelas, comentario)VALUES
('2025-11-25', 3, 2, 10, 'Placa de Video muito boa, roda tudo mesmo, só verifiquem se o seu processador aguenta, o meu xeon explodiu e pegou fogo, mas ela é muito boa.'),
('2025-09-02', 4, 8, 6, 'Boa para cortar carne, mas quebrou na hora de corta o osso da carne (de boi).'),
('2025-11-27', 2, 3, 9, 'Muito bom mesmo, o ruim é os 128gb que é pouco para o iphone.');
SELECT * FROM avaliacoes;
SELECT id_cliente, estrelas, comentario FROM avaliacoes ORDER BY estrelas DESC;-- imprime apenas as colunas id_clientes, estrelas e comentarios de avaliacoes em ordem decrecente de 'estrelas'

CREATE VIEW clientes_compras AS -- cria uma view (algo parecido com uma tabela secundaria, mas nao é considerado tabela) com o nome clientes_compras
SELECT clientes.nome, produtos.produto, pedidos_produtos.quantidade, pedidos.status
FROM pedidos JOIN clientes On pedidos.id_cliente = clientes.id_cliente -- o JOIN serve para fazer ligaçoes entre tabelas diferentes
JOIN pedidos_produtos ON pedidos.id_pedido = pedidos_produtos.id_pedido -- o ON é a condição dessa união
JOIN produtos ON pedidos_produtos.id_produto = produtos.id_produto;
SELECT * FROM clientes_compras;-- voce imprime a VIEW que voce acabou de criar
-- serve para simplificar consultas grande, inves de sempre escrever e copiar e colar um codigo gigante, voce so escreve ele uma vez, cria a VIEW e der um SELECT nela,
-- é um atalho para uma consulta


CREATE VIEW clientes_avaliacoes AS 
SELECT clientes.id_cliente, clientes.nome, avaliacoes.data_comentario, produtos.produto, avaliacoes.estrelas, avaliacoes.comentario
FROM avaliacoes
JOIN clientes ON avaliacoes.id_cliente = clientes.id_cliente
JOIN produtos ON avaliacoes.id_produto = produtos.id_produto;
SELECT * FROM clientes_avaliacoes;


CREATE VIEW produtos_baratos AS
SELECT produto, marca, categoria, preco FROM produtos WHERE preco < 100;
SELECT * FROM produtos_baratos;

CREATE VIEW regiao_cliente AS
SELECT clientes.nome, clientes.email, cep.numero_casa, cep.rua, cep.bairro, cep.municipio, cep.estado
FROM cep
JOIN clientes ON clientes.endereco = cep.id_cep;
SELECT * FROM regiao_cliente;
