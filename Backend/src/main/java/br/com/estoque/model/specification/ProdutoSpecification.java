package br.com.estoque.model.specification;

import br.com.estoque.model.Produto;
import br.com.estoque.model.enums.TipoProduto;
import jakarta.persistence.criteria.Predicate;
import org.springframework.data.jpa.domain.Specification;

public class ProdutoSpecification {

    public static Specification<Produto> filtrar(String codigo, String descricao, String categoria) {
        return (root, query, cb) -> {
            Predicate predicadoAtivo = cb.isTrue(root.get("ativo"));

            Predicate predicadoCodigo = codigo == null || codigo.isEmpty()
                    ? cb.conjunction()
                    : cb.like(cb.lower(root.get("codigo")), "%" + codigo.toLowerCase() + "%");

            Predicate predicadoDescricao = descricao == null || descricao.isEmpty()
                    ? cb.conjunction()
                    : cb.like(cb.lower(root.get("descricao")), "%" + descricao.toLowerCase() + "%");

            Predicate predicadoTipo = (categoria == null || categoria.isEmpty())
                    ? cb.conjunction()
                    : cb.equal(cb.upper(root.get("categoria").get("nome")), categoria.toUpperCase());

            return cb.and(predicadoAtivo, predicadoCodigo, predicadoDescricao, predicadoTipo);
        };
    }
}


