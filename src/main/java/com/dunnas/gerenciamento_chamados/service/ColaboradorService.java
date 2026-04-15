package com.dunnas.gerenciamento_chamados.service;

import com.dunnas.gerenciamento_chamados.model.Colaborador;
import com.dunnas.gerenciamento_chamados.repository.ColaboradorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ColaboradorService {

    private final ColaboradorRepository repository;

    @Transactional(readOnly = true)
    public List<Colaborador> listarTodos() {
        List<Colaborador> colaboradores = repository.findAll();
        // Carrega as categorias permitidas (escopo) para a lista
        colaboradores.forEach(c -> c.getCategoriasPermitidas().size());
        return colaboradores;
    }

    @Transactional(readOnly = true)
    public Colaborador buscarPorId(Long id) {
        Colaborador colab = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Colaborador não encontrado com o ID: " + id));

        // Carrega as categorias para que apareçam marcadas no formulário de edição
        colab.getCategoriasPermitidas().size();
        return colab;
    }

    @Transactional
    public void salvar(Colaborador colaborador) {
        repository.save(colaborador);
    }

    @Transactional
    public void deletar(Long id) {
        if (!repository.existsById(id)) {
            throw new RuntimeException("Colaborador não encontrado.");
        }
        repository.deleteById(id);
    }
}