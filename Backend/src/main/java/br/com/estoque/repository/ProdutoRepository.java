package br.com.estoque.repository;

import br.com.estoque.model.Produto;
import br.com.estoque.model.enums.TipoProduto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProdutoRepository extends JpaRepository<Produto, Long>, JpaSpecificationExecutor<Produto> {
    Optional<Produto> findByCodigo(String codigo);

    List<Produto> findByCategoriaNomeAndAtivoTrue(String nomeCategoria);

    Produto findTopByOrderByCodigoDesc();


}

