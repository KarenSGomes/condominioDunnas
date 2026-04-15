package com.dunnas.gerenciamento_chamados.repository;

import com.dunnas.gerenciamento_chamados.model.Administrador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AdministradorRepository extends JpaRepository<Administrador, Long> {

    // Método útil para o sistema de login ou para verificar e-mails duplicados
    Optional<Administrador> findByEmail(String email);

    // Verifica se já existe um administrador com o e-mail informado
    boolean existsByEmail(String email);
}