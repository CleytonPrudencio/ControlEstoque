package br.com.estoque.controller;

import br.com.estoque.model.Produto;
import br.com.estoque.service.ProdutoService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/produtos")
@RequiredArgsConstructor
public class ProdutoController {

    private final ProdutoService produtoService;

    @PostMapping
    public ResponseEntity<Produto> criar(@RequestBody Produto produto) {
        return ResponseEntity.ok(produtoService.salvar(produto));
    }

    @GetMapping
    public Page<Produto> listarProdutos(
            @RequestParam(required = false) String codigo,
            @RequestParam(required = false) String descricao,
            @RequestParam(required = false) String tipoProduto,
            Pageable pageable
    ) {
        return produtoService.buscarFiltrado(codigo, descricao, tipoProduto, pageable);
    }

    @GetMapping("/{id}")
    public Produto buscar(@PathVariable Long id) {
        return produtoService.buscarPorId(id);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Produto> atualizar(@PathVariable Long id, @RequestBody Produto produto) {
        Produto atualizado = produtoService.atualizar(id, produto);
        return ResponseEntity.ok(atualizado);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deletar(@PathVariable Long id) {
        produtoService.deletar(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/gerarCodigo")
    public ResponseEntity<String> novoCodigo() {
        String codigo = produtoService.gerarNovoCodigo();
        return ResponseEntity.ok(codigo);
    }

}
