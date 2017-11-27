CREATE TABLE pessoa
(
    id SERIAL PRIMARY KEY NOT NULL,
    cpf VARCHAR(11) NOT NULL,
    nome VARCHAR(150) NOT NULL,
    sobrenome VARCHAR(200) NOT NULL
);

CREATE TABLE cliente
(
    id INTEGER PRIMARY KEY NOT NULL,
    bandeiracc VARCHAR(100) NOT NULL,
    numerocc VARCHAR(50) NOT NULL,
    CONSTRAINT fk_cliente_pessoa FOREIGN KEY (id) REFERENCES pessoa (id)
);

CREATE UNIQUE INDEX uniq_cpf_pessoa ON pessoa (cpf);

CREATE TABLE produto
(
    id SERIAL PRIMARY KEY NOT NULL,
    nome VARCHAR(80) NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    preco DOUBLE PRECISION NOT NULL
);

CREATE UNIQUE INDEX uniq_nome_produto ON produto (nome);

CREATE TABLE venda
(
    id SERIAL PRIMARY KEY NOT NULL,
    venda_cliente INTEGER NOT NULL,
    data DATE NOT NULL,
    valor_total DOUBLE PRECISION NOT NULL,
    status BOOLEAN NOT NULL,
    CONSTRAINT fk_venda_cliente FOREIGN KEY (venda_cliente) REFERENCES cliente (id)
);

CREATE TABLE item_venda
(
    id SERIAL NOT NULL,
    fk_item_produto INTEGER NOT NULL,
    preco DOUBLE PRECISION NOT NULL,
    quantidade DOUBLE PRECISION NOT NULL,
    CONSTRAINT item_venda_pkey PRIMARY KEY (id, fk_item_produto),
    CONSTRAINT item_produto FOREIGN KEY (fk_item_produto) REFERENCES produto (id)
);

CREATE TABLE lista_venda
(
    id SERIAL NOT NULL,
    lista_item_id INTEGER NOT NULL,
    lista_item_prod INTEGER NOT NULL,
    venda_item INTEGER NOT NULL,
    CONSTRAINT lista_venda_pkey PRIMARY KEY (id, lista_item_id, lista_item_prod, venda_item),
    CONSTRAINT fk_lista_item FOREIGN KEY (lista_item_id, lista_item_prod) REFERENCES item_venda (id, fk_item_produto),
    CONSTRAINT fk_venda_item FOREIGN KEY (venda_item) REFERENCES venda (id)
);

