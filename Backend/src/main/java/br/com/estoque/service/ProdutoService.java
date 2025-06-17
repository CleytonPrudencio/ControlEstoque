package br.com.estoque.service;

import br.com.estoque.exception.NegocioException;
import br.com.estoque.model.MovimentoEstoque;
import br.com.estoque.model.Produto;
import br.com.estoque.model.enums.TipoMovimentacao;
import br.com.estoque.model.specification.ProdutoSpecification;
import br.com.estoque.repository.MovimentoEstoqueRepository;
import br.com.estoque.repository.ProdutoRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import org.springframework.data.domain.Pageable;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ProdutoService {

    private final ProdutoRepository produtoRepo;
    private final MovimentoEstoqueRepository movimentoRepo;

    public ProdutoService(ProdutoRepository produtoRepo, MovimentoEstoqueRepository movimentoRepo) {
        this.produtoRepo = produtoRepo;
        this.movimentoRepo = movimentoRepo;
    }

    public Produto salvar(Produto produto) {
        return produtoRepo.save(produto);
    }

    public List<Produto> listar() {
        return produtoRepo.findAll();
    }

    public Page<Produto> buscarFiltrado(String codigo, String descricao, String tipoProduto, Pageable pageable) {
        Specification<Produto> spec = ProdutoSpecification.filtrar(codigo, descricao, tipoProduto);
        return produtoRepo.findAll(spec, pageable);
    }


    public Produto buscarPorId(Long id) {
        return produtoRepo.findById(id)
                .orElseThrow(() -> new NegocioException("Produto não encontrado"));
    }

    public Produto atualizar(Long id, Produto produtoAtualizado) {
        Produto produtoExistente = buscarPorId(id);

        produtoExistente.setCodigo(produtoAtualizado.getCodigo());
        produtoExistente.setDescricao(produtoAtualizado.getDescricao());
        produtoExistente.setTipoProduto(produtoAtualizado.getTipoProduto());
        produtoExistente.setValorFornecedor(produtoAtualizado.getValorFornecedor());
        produtoExistente.setQuantidadeEstoque(produtoAtualizado.getQuantidadeEstoque());

        return produtoRepo.save(produtoExistente);
    }

    @Transactional
    public void deletar(Long id) {
        Produto produto = produtoRepo.findById(id)
                .orElseThrow(() -> new NegocioException("Produto não encontrado"));

        if (!produto.isAtivo()) {
            throw new NegocioException("Produto já está inativo");
        }


        produto.setAtivo(false);
        produtoRepo.save(produto);


        MovimentoEstoque movimentacaoExclusao = new MovimentoEstoque();
        movimentacaoExclusao.setProduto(produto);
        movimentacaoExclusao.setTipo(TipoMovimentacao.EXCLUSAO);
        movimentacaoExclusao.setQuantidade(produto.getQuantidadeEstoque());
        movimentacaoExclusao.setDataVenda(LocalDateTime.now());
        movimentacaoExclusao.setValorVenda(null);

        movimentoRepo.save(movimentacaoExclusao);
    }


    public String gerarNovoCodigo() {

        Produto produto = produtoRepo.findTopByOrderByCodigoDesc();

        if (produto == null || produto.getCodigo() == null) {
            return "P001";
        }

        String codigoAtual = produto.getCodigo();

        int numero = Integer.parseInt(codigoAtual.substring(1));

        int novoNumero = numero + 1;


        return String.format("P%03d", novoNumero);
    }

}
