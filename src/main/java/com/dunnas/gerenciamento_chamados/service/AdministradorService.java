package com.dunnas.gerenciamento_chamados.service;

import com.dunnas.gerenciamento_chamados.model.Administrador;
import com.dunnas.gerenciamento_chamados.repository.AdministradorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AdministradorService {

    private final AdministradorRepository repository;

    /**
     * Lista todos os administradores do sistema.
     */
    @Transactional(readOnly = true)
    public List<Administrador> listarTodos() {
        return repository.findAll();
    }

    /**
     * Busca um administrador pelo ID.
     */
    @Transactional(readOnly = true)
    public Administrador buscarPorId(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new RuntimeException("Administrador não encontrado com o ID: " + id));
    }

    /**
     * Salva ou atualiza um administrador.
     */
    @Transactional
    public void salvar(Administrador admin) {
        if (admin.getEmail() == null || admin.getEmail().isBlank()) {
            throw new IllegalArgumentException("O e-mail é obrigatório para um administrador.");
        }
        repository.save(admin);
    }

    /**
     * Deleta um administrador.
     * Implementa a trava de segurança para impedir que o sistema fique sem administradores.
     */
    @Transactional
    public void deletar(Long id) {
        // Verifica se o administrador existe
        if (!repository.existsById(id)) {
            throw new RuntimeException("Não foi possível excluir: Administrador inexistente.");
        }

        // REGRA DE SEGURANÇA: Conta quantos admins existem no banco
        long quantidadeAdmins = repository.count();

        // Se houver apenas 1, impede a exclusão para não deixar o sistema órfão
        if (quantidadeAdmins <= 1) {
            throw new RuntimeException("Operação negada: O sistema deve possuir pelo menos um administrador.");
        }

        repository.deleteById(id);
    }
}