package br.com.estoque.controller;

import br.com.estoque.dto.ExtratoProdutoCompleto;
import br.com.estoque.model.MovimentoEstoque;
import br.com.estoque.service.MovimentoEstoqueService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/movimentos")
@RequiredArgsConstructor
public class MovimentoEstoqueController {

    private final MovimentoEstoqueService movimentoService;

    @PostMapping
    public ResponseEntity<MovimentoEstoque> registrar(@RequestBody MovimentoEstoque movimento) {
        return ResponseEntity.ok(movimentoService.registrarMovimento(movimento));
    }

    @GetMapping
    public Page<MovimentoEstoque> listar(
            @RequestParam(required = false) String codigoProduto,
            @RequestParam(required = false) String tipoMovimento,
            @RequestParam(required = false) LocalDate dataInicio,
            @RequestParam(required = false) LocalDate dataFim,
            Pageable pageable
    ) {
        return movimentoService.buscarFiltrado(codigoProduto, tipoMovimento, dataInicio, dataFim, pageable);
    }

    @GetMapping("/saidas")
    public ResponseEntity<Map<Long, Long>> resumoSaidas() {
        Map<Long, Long> saidas = movimentoService.getTotalSaidasPorProduto();
        return ResponseEntity.ok(saidas);
    }


    @GetMapping("/extrato/{produtoId}")
    public ResponseEntity<ExtratoProdutoCompleto> getExtratoProduto(@PathVariable Long produtoId) {
        ExtratoProdutoCompleto extrato = movimentoService.gerarExtratoCompleto(produtoId);
        return ResponseEntity.ok(extrato);
    }

}

