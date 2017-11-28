CREATE DATABASE jdbc_work;

CREATE TABLE produto(
    id SERIAL NOT NULL CONSTRAINT produto_pkey PRIMARY KEY,
    nome VARCHAR(80) NOT NULL CONSTRAINT uniq_nome_produto UNIQUE,
    descricao VARCHAR(200) NOT NULL,
    preco DOUBLE PRECISION NOT NULL
);

CREATE TABLE pessoa(
    id SERIAL NOT NULL CONSTRAINT pessoa_pkey PRIMARY KEY,
    cpf VARCHAR(11) NOT NULL CONSTRAINT uniq_cpf_pessoa UNIQUE,
    nome VARCHAR(150) NOT NULL,
    sobrenome VARCHAR(200) NOT NULL
);

CREATE TABLE cliente(
    id INTEGER NOT NULL CONSTRAINT cliente_pkey PRIMARY KEY
        CONSTRAINT fk_cliente_pessoa
        REFERENCES pessoa,
    bandeiracc VARCHAR(100) NOT NULL,
    numerocc VARCHAR(50) NOT NULL
);

CREATE TABLE venda(
    id SERIAL NOT NULL CONSTRAINT venda_pkey PRIMARY KEY,
    venda_cliente INTEGER NOT NULL CONSTRAINT fk_venda_cliente
        REFERENCES cliente,
    data date NOT NULL,
    valor_total DOUBLE PRECISION NOT NULL,
    status BOOLEAN NOT NULL
);

CREATE TABLE item_venda(
    id SERIAL NOT NULL,
    fk_item_produto INTEGER NOT NULL CONSTRAINT fk_item_produto
    REFERENCES produto,
    preco DOUBLE PRECISION NOT NULL,
    quantidade DOUBLE PRECISION NOT NULL,
    fk_item_venda INTEGER NOT NULL CONSTRAINT fk_item_venda
    REFERENCES venda,
    PRIMARY KEY (id, fk_item_produto, fk_item_venda)
);


