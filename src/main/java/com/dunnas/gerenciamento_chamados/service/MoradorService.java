package com.dunnas.gerenciamento_chamados.service;

import com.dunnas.gerenciamento_chamados.model.Morador;
import com.dunnas.gerenciamento_chamados.repository.MoradorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class MoradorService {

    private final MoradorRepository repository;

    @Transactional
    public Morador salvar(Morador morador) {
        if (morador.getEmail() == null || morador.getEmail().isBlank()) {
            throw new IllegalArgumentException("O e-mail do morador é obrigatório.");
        }
        // O JPA entende que se o morador já tem ID, ele deve dar UPDATE em vez de INSERT
        return repository.save(morador);
    }

    @Transactional(readOnly = true)
    public List<Morador> listarTodos() {
        List<Morador> moradores = repository.findAll();
        // Garante que as unidades sejam carregadas para a listagem não dar erro 500 no JSP
        moradores.forEach(m -> m.getUnidades().size());
        return moradores;
    }

    @Transactional(readOnly = true)
    public Morador buscarPorId(Long id) {
        Morador morador = repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Morador não encontrado com o ID: " + id));

        // ESSENCIAL: Carrega a lista de unidades para o formulário de edição ou login
        morador.getUnidades().size();
        return morador;
    }

    @Transactional
    public void deletar(Long id) {
        // Antes de deletar, você poderia verificar se há chamados vinculados
        if (!repository.existsById(id)) {
            throw new RuntimeException("Não é possível deletar: Morador não encontrado.");
        }
        repository.deleteById(id);
    }
}