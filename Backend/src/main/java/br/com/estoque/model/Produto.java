package br.com.estoque.model;

import br.com.estoque.model.enums.TipoProduto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Entity
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Produto {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String codigo;

    private String descricao;

    @Enumerated(EnumType.STRING)
    private TipoProduto tipoProduto;

    private BigDecimal valorFornecedor;

    private Integer quantidadeEstoque;

    private boolean ativo = true;
}

