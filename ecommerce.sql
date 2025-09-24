-- Criação do banco
CREATE DATABASE ecommerce;
USE ecommerce;

-- ============================
-- TABELAS PRINCIPAIS
-- ============================

-- Cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(45) NOT NULL,
    Identificacao VARCHAR(45) NOT NULL,
    Endereco VARCHAR(45)
);

-- Fornecedor
CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    Razao_Social VARCHAR(45) NOT NULL,
    CNPJ VARCHAR(45) NOT NULL
);

-- Estoque
CREATE TABLE Estoque (
    idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    Local VARCHAR(45) NOT NULL
);

-- Produto
CREATE TABLE Produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    Categoria VARCHAR(45),
    Descricao VARCHAR(45),
    Valor VARCHAR(45)
);

-- Terceiro_Vendedor
CREATE TABLE Terceiro_Vendedor (
    idTerceiro_Vendedor INT AUTO_INCREMENT PRIMARY KEY,
    Razao_Social VARCHAR(45) NOT NULL,
    Local VARCHAR(45)
);

-- Pedido
CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    Status_pedido VARCHAR(45) NOT NULL,
    Descricao VARCHAR(45),
    Cliente_idCliente INT NOT NULL,
    Frete FLOAT,
    FOREIGN KEY (Cliente_idCliente) REFERENCES Cliente(idCliente)
);

-- ============================
-- TABELAS DE RELACIONAMENTO
-- ============================

-- Disponibilizando_um_produto (Fornecedor x Produto)
CREATE TABLE Disponibilizando_um_produto (
    Fornecedor_idFornecedor INT NOT NULL,
    Produto_idProduto INT NOT NULL,
    PRIMARY KEY (Fornecedor_idFornecedor, Produto_idProduto),
    FOREIGN KEY (Fornecedor_idFornecedor) REFERENCES Fornecedor(idFornecedor),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto)
);

-- Produto_has_Estoque (Produto x Estoque)
CREATE TABLE Produto_has_Estoque (
    Produto_idProduto INT NOT NULL,
    Estoque_idEstoque INT NOT NULL,
    Quantidade INT NOT NULL,
    PRIMARY KEY (Produto_idProduto, Estoque_idEstoque),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto),
    FOREIGN KEY (Estoque_idEstoque) REFERENCES Estoque(idEstoque)
);

-- Produtos_por_Vendedor (Terceiro_Vendedor x Produto)
CREATE TABLE Produtos_por_Vendedor (
    Terceiro_Vendedor_idTerceiro_Vendedor INT NOT NULL,
    Produto_idProduto INT NOT NULL,
    Quantidade INT NOT NULL,
    PRIMARY KEY (Terceiro_Vendedor_idTerceiro_Vendedor, Produto_idProduto),
    FOREIGN KEY (Terceiro_Vendedor_idTerceiro_Vendedor) REFERENCES Terceiro_Vendedor(idTerceiro_Vendedor),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto)
);

-- Relacao_de_Produto_Pedido (Produto x Pedido)
CREATE TABLE Relacao_de_Produto_Pedido (
    Produto_idProduto INT NOT NULL,
    Pedido_idPedido INT NOT NULL,
    Quantidade VARCHAR(45),
    PRIMARY KEY (Produto_idProduto, Pedido_idPedido),
    FOREIGN KEY (Produto_idProduto) REFERENCES Produto(idProduto),
    FOREIGN KEY (Pedido_idPedido) REFERENCES Pedido(idPedido)
);


###############

CREATE DATABASE ecommerce;
USE ecommerce;

CREATE TABLE client(
	idClient int AUTO_INCREMENT PRIMARY KEY,
	Fname varchar(10),
	Minit char(3),
	Lanme varchar(20),
	CPF char(11) NOT NULL ,
	Address varcha(30),
	CONSTRAINT unique_cpf_client UNIQUE (CPF)
)

CREATE TABLE  product(
	idProduct int AUTO_INCREMENT PRIMARY KEY,
	Pname varchar(30) NOT null,
	classification_kid bool DEFAULT false,
	category enum('Eletro','Vestuario','Brincendos','Alimentos') NOT NULL ,
	avaliacao float DEFAULT 0,
	size_w varchar(10)
	CONSTRAINT unique_cpf_client UNIQUE(CPF)
	
)


CREATE TABLE orders(
	idOrder int AUTO_INCREMENT PRIMARY KEY,
	idOrderClient int,
	orderStatus enum('Cancelado','Confirmado','Em Processamento') NOT NULL,
	orderDescrition varchar(255),
	sendValue float DEFAULT  10,
	paymentCash bool DEFAULT false
	CONSTRAINT fk_onrder_client FOREIGN KEY (idOrderClient) REFERENCES clients(idClinet) 
	ON UPDATE CASCADE
	ON DELETE SET NULL
)

-- cria tabeka estoque
CREATE TABLE productStorage(
	idProdStorage int AUTO_INCREMENT PRIMARY KEY,
	storageLocation varchar(255),
	quantity int DEFAULT 0
);

-- criando tabel fornecedor
CREATE TABLE supplier(
	idSupplier int AUTO_INCREMENT PRIMARY KEY,
	SocialName varchar(255) NOT NULL,
	CNPJ char(15) NOT NULL,
	contact char(11) NOT NULL,
	CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- criando vendedor
CREATE TABLE seller(
 idSeller int AUTO_INCREMENT PRIMARY KEY,
 SocialName varchar(255) NOT NULL,
 AbstName varchar(255),
 CNPJ char(15),
 CPF char(9),
 location varchar(255),
 contact char(11) NOT NULL,
 CONSTRAINT unique_cnpj_seller unique(CNPJ),
 CONSTRAINT unique_cpf_seller unique(CPF)
);

CREATE TABLE productSeller(
 idSeller int,
 idProduct int,
 prodQuantity int DEFAULT 1,
 PRIMARY KEY (idSeller,idProduct),
 CONSTRAINT fk_product_seller FOREIGN KEY (idSeller) REFERENCES seller(idSeller),
 CONSTRAINT fk_product_product FOREIGN  KEY (idProduct) REFERENCES product(idProduct)
);

CREATE TABLE productOrder(
	idPOproduct int,
	idPOorder int,
	poQuantity int DEFAULT 1,
	poStatus enum('Disponivel','Sem Estoque') DEFAULT 'Disponivel',
	PRIMARY KEY (idPOproduct,idPOorder),
	CONSTRAINT fk_product_seller FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
 	CONSTRAINT fk_product_product FOREIGN  KEY (idPOorder) REFERENCES orders(idOrder)
),

CREATE TABLE storageLocation(
	idLproduct int,
	idLstorage int,
	location varchar(255) NOT NULL,
	PRIMARY KEY (idLproduct,idLstorage),
	CONSTRAINT fk_product_seller FOREIGN KEY (idLproduct) REFERENCES product(idPorduct)
	CONSTRAINT fk_product_product FOREIGN KEY (idLstorage) REFERENCES order(productSeller)
);

USE ecommerce;

CREATE TABLE  productSupplier(
idPsSupplier int,
idPsProduct int,
quantity int NOT NULL,
PRIMARY KEY (idPsSupplier,idPsProduct),
CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES supplier(idSupplier),
CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES product(idProduct)
)


