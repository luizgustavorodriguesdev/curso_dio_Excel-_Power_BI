
-- Criação do banco
CREATE DATABASE e_commerce;
USE e_commerce;

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

INSERT INTO Cliente (Nome, Identificacao, Endereco) VALUES
('João Silva', '11122233344', 'Rua das Flores, 123'),
('Maria Souza', '55566677788', 'Av. Paulista, 456');

INSERT INTO Fornecedor (Razao_Social, CNPJ) VALUES
('Tech Distribuidora', '12.345.678/0001-99'),
('Super Importadora', '98.765.432/0001-55');

INSERT INTO Estoque (Local) VALUES
('Centro SP'),
('Rio de Janeiro');

INSERT INTO Produto (Categoria, Descricao, Valor) VALUES
('Eletrônicos', 'Smartphone X', '2500.00'),
('Eletrodomésticos', 'Geladeira Frost', '3800.00'),
('Informática', 'Notebook Gamer', '5500.00');

INSERT INTO Pedido (Status_pedido, Descricao, Cliente_idCliente, Frete) VALUES
('Em processamento', 'Compra de smartphone e notebook', 1, 50.00),
('Concluído', 'Compra de geladeira', 2, 120.00);


-- ============================
-- TABELAS DE RELACIONAMENTO
-- ============================

-- Fornecedor fornecendo produtos
INSERT INTO Disponibilizando_um_produto (Fornecedor_idFornecedor, Produto_idProduto) VALUES
(1, 1), -- Tech Distribuidora fornece Smartphone
(1, 3), -- Tech Distribuidora fornece Notebook
(2, 2); -- Super Importadora fornece Geladeira


-- Produto em estoque
INSERT INTO Produto_has_Estoque (Produto_idProduto, Estoque_idEstoque, Quantidade) VALUES
(1, 1, 100), -- 100 Smartphones em SP
(2, 2, 50),  -- 50 Geladeiras no RJ
(3, 1, 30);  -- 30 Notebooks em SP

-- Produtos vendidos por terceiros
INSERT INTO Produtos_por_Vendedor (Terceiro_Vendedor_idTerceiro_Vendedor, Produto_idProduto, Quantidade) VALUES
(1, 1, 20), -- Loja Tech Online vende Smartphone
(2, 3, 10); -- Gamer Store vende Notebook

-- Relação Produto x Pedido
INSERT INTO Relacao_de_Produto_Pedido (Produto_idProduto, Pedido_idPedido, Quantidade) VALUES
(1, 1, '1'), -- Pedido 1 contém 1 Smartphone
(3, 1, '1'), -- Pedido 1 contém 1 Notebook
(2, 2, '1'); -- Pedido 2 contém 1 Geladeira



-- Listar todos os clientes
SELECT * FROM Cliente;

-- Mostrar apenas nome e identificação
SELECT Nome, Identificacao FROM Cliente;

-- Listar todos os produtos
SELECT idProduto, Categoria, Descricao, Valor FROM Produto;



-- Clientes com identificação que começa com '111'
SELECT * FROM Cliente
WHERE Identificacao LIKE '111%';

-- Produtos da categoria Eletrônicos
SELECT * FROM Produto
WHERE Categoria = 'Eletrônicos';

-- Pedidos concluídos
SELECT * FROM Pedido
WHERE Status_pedido = 'Concluído';


-- Criar uma coluna derivada: valor total (produto * quantidade em estoque)
SELECT 
    p.Descricao,
    pe.Quantidade,
    CAST(p.Valor AS DECIMAL(10,2)) * pe.Quantidade AS Valor_Total_Estoque
FROM Produto p
JOIN Produto_has_Estoque pe ON p.idProduto = pe.Produto_idProduto;

-- Valor total de cada pedido (frete + soma dos produtos)
SELECT 
    ped.idPedido,
    ped.Descricao,
    SUM(CAST(pr.Valor AS DECIMAL(10,2)) * rp.Quantidade) + ped.Frete AS Valor_Total
FROM Pedido ped
JOIN Relacao_de_Produto_Pedido rp ON ped.idPedido = rp.Pedido_idPedido
JOIN Produto pr ON rp.Produto_idProduto = pr.idProduto
GROUP BY ped.idPedido;


-- Produtos ordenados pelo preço (maior para menor)
SELECT Descricao, CAST(Valor AS DECIMAL(10,2)) AS Preco
FROM Produto
ORDER BY Preco DESC;


-- Produtos com estoque total maior que 50 unidades
SELECT 
    p.Descricao,
    SUM(pe.Quantidade) AS Total_Estoque
FROM Produto p
JOIN Produto_has_Estoque pe ON p.idProduto = pe.Produto_idProduto
GROUP BY p.Descricao
HAVING SUM(pe.Quantidade) > 50;


-- Listar todos os pedidos com nome do cliente e produtos associados
SELECT 
    ped.idPedido,
    c.Nome AS Cliente,
    pr.Descricao AS Produto,
    rp.Quantidade,
    ped.Frete
FROM Pedido ped
JOIN Cliente c ON ped.Cliente_idCliente = c.idCliente
JOIN Relacao_de_Produto_Pedido rp ON ped.idPedido = rp.Pedido_idPedido
JOIN Produto pr ON rp.Produto_idProduto = pr.idProduto;