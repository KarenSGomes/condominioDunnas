package com.dunnas.gerenciamento_chamados.service;

import com.dunnas.gerenciamento_chamados.model.Categoria;
import com.dunnas.gerenciamento_chamados.repository.CategoriaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoriaService {

    private final CategoriaRepository repository;

    public List<Categoria> listarTodas() {
        return repository.findAll();
    }

    @Transactional
    public void salvar(Categoria categoria) {
        // Validação de segurança no banco
        if (categoria.getPrazoEstimado() != null && categoria.getPrazoEstimado() < 0) {
            throw new RuntimeException("O prazo não pode ser negativo.");
        }
        repository.save(categoria);
    }

    public Categoria buscarPorId(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));
    }
}