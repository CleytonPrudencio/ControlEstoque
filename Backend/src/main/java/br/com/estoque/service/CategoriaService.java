package br.com.estoque.service;

import br.com.estoque.model.Categoria;
import br.com.estoque.repository.CategoriaRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoriaService {

    private final CategoriaRepository repository;

    public CategoriaService(CategoriaRepository repository) {
        this.repository = repository;
    }

    public List<Categoria> listar() {
        return repository.findAll();
    }

    public Categoria salvar(Categoria categoria) {
        String nomeMaiusculo = categoria.getNome().toUpperCase();
        categoria.setNome(nomeMaiusculo);

        if (repository.existsByNomeIgnoreCase(nomeMaiusculo)) {
            throw new RuntimeException("Categoria já existe");
        }

        return repository.save(categoria);
    }


    public void excluir(Long id) {
        if (!repository.existsById(id)) {
            throw new RuntimeException("Categoria não encontrada");
        }
        repository.deleteById(id);
    }
}

