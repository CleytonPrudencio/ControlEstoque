CREATE TABLE produto (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(100),
  descricao VARCHAR(255),
  tipo_produto VARCHAR(50),
  valor_fornecedor DECIMAL(15, 2),
  quantidade_estoque INT,
  ativo BOOLEAN DEFAULT TRUE NOT NULL
);


CREATE TABLE movimento_estoque (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  produto_id BIGINT,
  tipo VARCHAR(20),
  valor_venda DECIMAL,
  data_venda TIMESTAMP,
  quantidade INT,
  FOREIGN KEY (produto_id) REFERENCES produto(id)
);
