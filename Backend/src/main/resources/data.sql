INSERT INTO categoria (nome) VALUES
('ELETRONICO'),
('ELETRODOMESTICO'),
('MOVEL');

INSERT INTO produto (codigo, descricao, valor_fornecedor, categoria_id) VALUES
('P001', 'Notebook Dell', 3500.00, (SELECT id FROM categoria WHERE nome = 'ELETRONICO')),
('P002', 'Geladeira Brastemp', 2400.00, (SELECT id FROM categoria WHERE nome = 'ELETRODOMESTICO')),
('P003', 'Mesa de Escritório', 800.00, (SELECT id FROM categoria WHERE nome = 'MOVEL')),
('P004', 'Smartphone Samsung', 1500.00, (SELECT id FROM categoria WHERE nome = 'ELETRONICO')),
('P005', 'Micro-ondas LG', 600.00, (SELECT id FROM categoria WHERE nome = 'ELETRODOMESTICO')),
('P006', 'Cadeira Escritório', 350.00, (SELECT id FROM categoria WHERE nome = 'MOVEL')),
('P007', 'Impressora HP', 700.00, (SELECT id FROM categoria WHERE nome = 'ELETRONICO')),
('P008', 'Ventilador Arno', 150.00, (SELECT id FROM categoria WHERE nome = 'ELETRODOMESTICO')),
('P009', 'Estante de Madeira', 900.00, (SELECT id FROM categoria WHERE nome = 'MOVEL')),
('P010', 'Monitor LG', 1100.00, (SELECT id FROM categoria WHERE nome = 'ELETRONICO')),
('P011', 'Fogão Electrolux', 1800.00, (SELECT id FROM categoria WHERE nome = 'ELETRODOMESTICO')),
('P012', 'Sofá 3 lugares', 1200.00, (SELECT id FROM categoria WHERE nome = 'MOVEL')),
('P013', 'Caixa de Som JBL', 400.00, (SELECT id FROM categoria WHERE nome = 'ELETRONICO')),
('P014', 'Liquidificador Philips', 220.00, (SELECT id FROM categoria WHERE nome = 'ELETRODOMESTICO')),
('P015', 'Mesa de Jantar', 1300.00, (SELECT id FROM categoria WHERE nome = 'MOVEL')),
('P016', 'Notebook Asus', 4000.00, (SELECT id FROM categoria WHERE nome = 'ELETRONICO')),
('P017', 'Geladeira Consul', 2600.00, (SELECT id FROM categoria WHERE nome = 'ELETRODOMESTICO')),
('P018', 'Poltrona Reclinável', 1500.00, (SELECT id FROM categoria WHERE nome = 'MOVEL')),
('P019', 'Tablet Samsung', 1200.00, (SELECT id FROM categoria WHERE nome = 'ELETRONICO')),
('P020', 'Torradeira Britânia', 180.00, (SELECT id FROM categoria WHERE nome = 'ELETRODOMESTICO')),
('P021', 'Armário de Cozinha', 1100.00, (SELECT id FROM categoria WHERE nome = 'MOVEL')),
('P022', 'Headphone Sony', 350.00, (SELECT id FROM categoria WHERE nome = 'ELETRONICO'));



INSERT INTO movimento_estoque (produto_id, tipo, valor_venda, data_venda, quantidade, descricao) VALUES
-- Entradas
((SELECT id FROM produto WHERE codigo = 'P001'), 'ENTRADA', NULL, '2025-06-01 08:00:00', 10, 'Entrada de 10 unidades do produto P001.'),
((SELECT id FROM produto WHERE codigo = 'P002'), 'ENTRADA', NULL, '2025-06-02 09:30:00', 5, 'Entrada de 5 unidades do produto P002.'),
((SELECT id FROM produto WHERE codigo = 'P003'), 'ENTRADA', NULL, '2025-06-03 10:15:00', 15, 'Entrada de 15 unidades do produto P003.'),
((SELECT id FROM produto WHERE codigo = 'P004'), 'ENTRADA', NULL, '2025-06-04 11:00:00', 20, 'Entrada de 20 unidades do produto P004.'),
((SELECT id FROM produto WHERE codigo = 'P005'), 'ENTRADA', NULL, NULL, 8, 'Entrada de 8 unidades do produto P005.'),
((SELECT id FROM produto WHERE codigo = 'P006'), 'ENTRADA', NULL, '2025-06-05 14:00:00', 12, 'Entrada de 12 unidades do produto P006.'),
((SELECT id FROM produto WHERE codigo = 'P007'), 'ENTRADA', NULL, '2025-06-06 15:30:00', 6, 'Entrada de 6 unidades do produto P007.'),
((SELECT id FROM produto WHERE codigo = 'P008'), 'ENTRADA', NULL, '2025-06-07 16:45:00', 10, 'Entrada de 10 unidades do produto P008.'),
((SELECT id FROM produto WHERE codigo = 'P009'), 'ENTRADA', NULL, NULL, 7, 'Entrada de 7 unidades do produto P009.'),
((SELECT id FROM produto WHERE codigo = 'P010'), 'ENTRADA', NULL, '2025-06-08 09:00:00', 9, 'Entrada de 9 unidades do produto P010.'),
((SELECT id FROM produto WHERE codigo = 'P011'), 'ENTRADA', NULL, '2025-06-09 10:30:00', 4, 'Entrada de 4 unidades do produto P011.'),
((SELECT id FROM produto WHERE codigo = 'P012'), 'ENTRADA', NULL, '2025-06-10 11:00:00', 3, 'Entrada de 3 unidades do produto P012.'),
((SELECT id FROM produto WHERE codigo = 'P013'), 'ENTRADA', NULL, '2025-06-11 12:15:00', 14, 'Entrada de 14 unidades do produto P013.'),
((SELECT id FROM produto WHERE codigo = 'P014'), 'ENTRADA', NULL, '2025-06-12 13:20:00', 11, 'Entrada de 11 unidades do produto P014.'),
((SELECT id FROM produto WHERE codigo = 'P015'), 'ENTRADA', NULL, NULL, 2, 'Entrada de 2 unidades do produto P015.'),

-- Saídas
((SELECT id FROM produto WHERE codigo = 'P001'), 'SAIDA', 4000.00, '2025-06-16 00:00:00', 2, 'Venda de 2 unidades por R$ 4000.00.'),
((SELECT id FROM produto WHERE codigo = 'P003'), 'SAIDA', 1000.00, '2025-06-15 00:00:00', 1, 'Venda de 1 unidade por R$ 1000.00.'),
((SELECT id FROM produto WHERE codigo = 'P004'), 'SAIDA', 1600.00, '2025-06-14 00:00:00', 3, 'Venda de 3 unidades por R$ 1600.00.'),
((SELECT id FROM produto WHERE codigo = 'P006'), 'SAIDA', 400.00, '2025-06-14 00:00:00', 2, 'Venda de 2 unidades por R$ 400.00.'),
((SELECT id FROM produto WHERE codigo = 'P009'), 'SAIDA', 700.00, '2025-06-13 00:00:00', 1, 'Venda de 1 unidade por R$ 700.00.'),
((SELECT id FROM produto WHERE codigo = 'P010'), 'SAIDA', 1100.00, '2025-06-13 00:00:00', 2, 'Venda de 2 unidades por R$ 1100.00.'),
((SELECT id FROM produto WHERE codigo = 'P012'), 'SAIDA', 1200.00, '2025-06-12 00:00:00', 1, 'Venda de 1 unidade por R$ 1200.00.'),
((SELECT id FROM produto WHERE codigo = 'P014'), 'SAIDA', 230.00, '2025-06-12 00:00:00', 3, 'Venda de 3 unidades por R$ 230.00.'),
((SELECT id FROM produto WHERE codigo = 'P017'), 'SAIDA', 2600.00, '2025-06-11 00:00:00', 1, 'Venda de 1 unidade por R$ 2600.00.'),
((SELECT id FROM produto WHERE codigo = 'P019'), 'SAIDA', 1300.00, '2025-06-11 00:00:00', 4, 'Venda de 4 unidades por R$ 1300.00.'),
((SELECT id FROM produto WHERE codigo = 'P020'), 'SAIDA', 200.00, '2025-06-10 00:00:00', 5, 'Venda de 5 unidades por R$ 200.00.'),
((SELECT id FROM produto WHERE codigo = 'P022'), 'SAIDA', 360.00, '2025-06-09 00:00:00', 2, 'Venda de 2 unidades por R$ 360.00.'),
((SELECT id FROM produto WHERE codigo = 'P021'), 'SAIDA', 1100.00, '2025-06-09 00:00:00', 1, 'Venda de 1 unidade por R$ 1100.00.'),

-- Edições
((SELECT id FROM produto WHERE codigo = 'P001'), 'EDITADO', NULL, '2025-06-17 10:00:00', 8, 'Quantidade editada de 10 para 8. Valor fornecedor alterado de R$ 300.00 para R$ 350.00.'),
((SELECT id FROM produto WHERE codigo = 'P006'), 'EDITADO', NULL, '2025-06-17 10:30:00', 10, 'Descrição alterada de "Produto X" para "Produto X Premium". Quantidade alterada de 12 para 10.'),
((SELECT id FROM produto WHERE codigo = 'P014'), 'EDITADO', NULL, '2025-06-17 11:00:00', 15, 'Categoria alterada de "Informática" para "Eletrônicos". Estoque alterado de 11 para 15.');


UPDATE produto p
SET quantidade_estoque = GREATEST((
  SELECT
    COALESCE(SUM(CASE WHEN m.tipo = 'ENTRADA' THEN m.quantidade ELSE 0 END), 0) -
    COALESCE(SUM(CASE WHEN m.tipo = 'SAIDA' THEN m.quantidade ELSE 0 END), 0)
  FROM movimento_estoque m
  WHERE m.produto_id = p.id
), 0);

