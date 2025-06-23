DROP TABLE IF EXISTS movimento_estoque;
DROP TABLE IF EXISTS produto;
DROP TABLE IF EXISTS categoria;

CREATE TABLE categoria (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE produto (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  codigo VARCHAR(100),
  descricao VARCHAR(255),
  valor_fornecedor DECIMAL(15, 2),
  quantidade_estoque INT,
  ativo BOOLEAN DEFAULT TRUE NOT NULL,
  categoria_id BIGINT,
  FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);

CREATE TABLE movimento_estoque (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  produto_id BIGINT NOT NULL,
  tipo VARCHAR(20) NOT NULL, -- 'ENTRADA', 'SAIDA', 'EDITADO', etc.
  valor_venda DECIMAL(15,2),
  data_venda TIMESTAMP,
  quantidade INT NOT NULL,
  descricao TEXT, -- Campo para detalhar o que foi feito na movimentação
  FOREIGN KEY (produto_id) REFERENCES produto(id)
);

