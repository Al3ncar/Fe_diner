--  LANCHONETE DA FE  –  Sistema de Pedidos
--  Banco de Dados: PostgreSQL
--  Titulo: Desafio Técnico Backend
--  Autor: Igor Bastos Alencar

-- DDL: CCRIANDO TABELAS

CREATE TABLE tbl_loja (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    local_loja VARCHAR(100) NOT NULL
);

CREATE TABLE tbl_clientes (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    endereco VARCHAR(200),
    criado_em TIMESTAMP DEFAULT NOW()
);

CREATE TABLE tbl_categoria (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE tbl_produto (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    categoria_id INT NOT NULL,
    local_loja_id INT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco NUMERIC(10, 2) NOT NULL CHECK (preco >= 0),
    disponivel BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (categoria_id) REFERENCES tbl_categoria (id),
    FOREIGN KEY (local_loja_id) REFERENCES tbl_loja (id)
);

CREATE TABLE tbl_funcionarios (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cargo VARCHAR(55),
    ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE tbl_pedidos (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    clientes_id INT NOT NULL,
    funcionario_id INT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDENTE',
    observacao TEXT,
    criado_em TIMESTAMP DEFAULT NOW(),
    atualizado_em TIMESTAMP DEFAULT NOW(),
    FOREIGN KEY (clientes_id) REFERENCES tbl_clientes (id),
    FOREIGN KEY (funcionario_id) REFERENCES tbl_funcionarios (id)
);

CREATE TABLE tbl_itens_pedido (
    id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    local_loja_id INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario NUMERIC(8, 2) NOT NULL,
    subtotal NUMERIC(8, 2) GENERATED ALWAYS AS (quantidade * preco_unitario) STORED,
    FOREIGN KEY (pedido_id) REFERENCES tbl_pedidos (id) ON DELETE CASCADE,
    FOREIGN KEY (produto_id) REFERENCES tbl_produto (id),
    FOREIGN KEY (local_loja_id) REFERENCES tbl_loja (id)
);

-- DML: DADOS DE EXEMPLO

INSERT INTO tbl_loja (local_loja) VALUES ('São Paulo - SP')

INSERT INTO
    tbl_categoria (nome)
VALUES ('Lanche'),
    ('Bebida'),
    ('Sobremesa'),
    ('Acompanhamento');

INSERT INTO
    tbl_produto (
        categoria_id,
        local_loja_id,
        nome,
        descricao,
        preco
    )
VALUES (
        1,
        1,
        'X-Burgão',
        'Hambúrguer artesanal 180g com queijo, alface e tomate',
        22.90
    ),
    (
        1,
        1,
        'X-Frango',
        'Frango grelhado com maionese da casa',
        18.50
    ),
    (
        1,
        1,
        'Veggie Burger',
        'Hambúrguer de grão-de-bico com cream cheese',
        19.90
    ),
    (
        2,
        1,
        'Suco de Laranja',
        'Suco natural 400ml',
        8.00
    ),
    (
        2,
        1,
        'Refrigerante',
        'Lata 350ml',
        5.50
    ),
    (
        2,
        1,
        'Água Mineral',
        'Garrafa 500ml',
        3.00
    ),
    (
        3,
        1,
        'Brownie',
        'Brownie de chocolate meio amargo',
        9.00
    ),
    (
        3,
        1,
        'Açaí 300ml',
        'Açaí com granola e banana',
        14.00
    ),
    (
        4,
        1,
        'Batata Frita',
        'Porção 200g',
        11.00
    ),
    (
        4,
        1,
        'Onion Rings',
        'Anéis de cebola empanados',
        12.00
    );

INSERT INTO
    tbl_clientes (
        nome,
        email,
        telefone,
        endereco
    )
VALUES (
        'Ana Paula Ferreira',
        'anapaula@gmail.com',
        '(11) 91234-5678',
        'Rua das Flores, 42 – Apto 3'
    ),
    (
        'Carlos Eduardo Lima',
        'caloseduardo@gmail.com',
        '(11) 99876-5432',
        'Av. Central, 150'
    ),
    (
        'Beatriz Souza',
        'beatrizsousa@gmail.com',
        '(11) 97654-3210',
        'Rua do Comércio, 8'
    ),
    (
        'Rodrigo Mendes',
        'rodrigomendes@gmail.com',
        '(11) 98888-1111',
        NULL
    );

INSERT INTO
    tbl_funcionarios (nome, cargo)
VALUES (
        'Zé da Lanchonete',
        'Proprietário'
    ),
    ('Maria Silva', 'Atendente'),
    ('João Oliveira', 'Cozinheiro');

INSERT INTO
    tbl_pedidos (
        clientes_id,
        funcionario_id,
        tipo,
        status,
        observacao
    )
VALUES (
        1,
        2,
        'local',
        'entregue',
        'Sem cebola no lanche'
    ),
    (
        2,
        2,
        'retirada',
        'pronto',
        NULL
    ),
    (
        3,
        2,
        'delivery',
        'em_preparo',
        'Entregar no interfone 302'
    ),
    (
        4,
        2,
        'local',
        'pendente',
        NULL
    ),
    (
        1,
        2,
        'local',
        'cancelado',
        'Cliente desistiu'
    );

INSERT INTO
    tbl_itens_pedido (
        pedido_id,
        produto_id,
        local_loja_id,
        quantidade,
        preco_unitario
    )
VALUES (1, 1, 1, 1, 22.90),
    (1, 4, 1, 1, 8.00),
    (1, 7, 1, 1, 9.00),
    (2, 2, 1, 1, 18.50),
    (2, 9, 1, 1, 11.00),
    (2, 5, 1, 1, 5.50),
    (3, 3, 1, 1, 19.90),
    (3, 6, 1, 2, 3.00),
    (4, 1, 1, 2, 22.90),
    (4, 10, 1, 1, 12.00);

-- QUERIES – CONSULTAS ÚTEIS PARA O NEGÓCIO

-- Analisar todas as tabelas e suas informações inseridas
SELECT * FROM tbl_loja;

SELECT * FROM tbl_categoria;

SELECT * FROM tbl_produto;

SELECT * FROM tbl_clientes;

SELECT * FROM tbl_funcionarios;

SELECT * FROM tbl_pedidos;

SELECT * FROM tbl_itens_pedido;

-- Todos os pedidos com status atual e nome do cliente
SELECT ped.id AS pedido_id, COALESCE(
        cli.nome, 'Cliente não informado'
    ) AS cliente, ped.tipo, ped.status, COALESCE(ped.observacao, '-'), ped.criado_em
FROM
    tbl_pedidos AS ped
    LEFT JOIN tbl_clientes cli ON cli.id = ped.clientes_id
ORDER BY ped.criado_em DESC;

-- Valor total de cada pedido
SELECT
    ped.id AS pedido_id,
    COALESCE(
        cli.nome,
        'Cliente não informado'
    ) AS cliente,
    ped.status,
    SUM(item.subtotal) AS total
FROM
    tbl_pedidos ped
    LEFT JOIN tbl_clientes cli ON cli.id = ped.clientes_id
    JOIN tbl_itens_pedido item ON item.pedido_id = ped.id
GROUP BY
    ped.id,
    cli.nome,
    ped.status
ORDER BY ped.id;

-- Pedidos em aberto (pendente ou em preparo)
SELECT ped.id, COALESCE(
        cli.nome, 'Cliente não informado'
    ) AS cliente, ped.tipo, ped.status, COALESCE(ped.observacao, '-'), ped.criado_em
FROM
    tbl_pedidos ped
    LEFT JOIN tbl_clientes cli ON cli.id = ped.clientes_id
WHERE
    ped.status IN ('pendente', 'em_preparo')
ORDER BY ped.criado_em;

-- Produtos mais vendidos (ranking)
SELECT
    prod.nome AS produto,
    SUM(item.quantidade) AS qtd_vendida,
    SUM(item.subtotal) AS receita_gerada
FROM
    tbl_itens_pedido item
    JOIN tbl_pedidos ped ON ped.id = item.pedido_id
    JOIN tbl_produto prod ON prod.id = item.produto_id
WHERE
    ped.status <> 'cancelado'
GROUP BY
    prod.nome
ORDER BY qtd_vendida DESC;

-- Faturamento por categoria
SELECT
    cat.nome AS categoria,
    SUM(item.quantidade) AS itens_vendidos,
    SUM(item.subtotal) AS faturamento
FROM
    tbl_itens_pedido item
    JOIN tbl_pedidos ped ON ped.id = item.pedido_id
    JOIN tbl_produto prod ON prod.id = item.produto_id
    JOIN tbl_categoria cat ON cat.id = prod.categoria_id
WHERE
    ped.status <> 'cancelado'
GROUP BY
    cat.nome
ORDER BY faturamento DESC;

-- Histórico de pedidos de um cliente específico
SELECT ped.id AS pedido_id, ped.tipo, ped.status, SUM(item.subtotal) AS total, ped.criado_em
FROM
    tbl_pedidos ped
    JOIN tbl_itens_pedido item ON item.pedido_id = ped.id
WHERE
    ped.clientes_id = 1 -- ID do cliente desejado
GROUP BY
    ped.id
ORDER BY ped.criado_em DESC;

-- Faturamento total (excluindo cancelados)
SELECT SUM(item.subtotal) AS faturamento_total
FROM
    tbl_itens_pedido item
    JOIN tbl_pedidos ped ON ped.id = item.pedido_id
WHERE
    ped.status <> 'cancelado';