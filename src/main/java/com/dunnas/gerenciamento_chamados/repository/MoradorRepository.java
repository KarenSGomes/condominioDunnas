package com.dunnas.gerenciamento_chamados.repository;

import com.dunnas.gerenciamento_chamados.model.Morador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface MoradorRepository extends JpaRepository<Morador, Long> {
    // Busca um morador pelo e-mail (campo herdado de Usuario)
    Optional<Morador> findByEmail(String email);

    // Busca por CPF
    Optional<Morador> findByCpf(String cpf);

    // Verifica se já existe um e-mail cadastrado antes de salvar
    boolean existsByEmail(String email);
}