package com.dunnas.gerenciamento_chamados.repository;

import com.dunnas.gerenciamento_chamados.model.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {
    // Caso precise buscar por nome futuramente:
    // Categoria findByNome(String nome);
}