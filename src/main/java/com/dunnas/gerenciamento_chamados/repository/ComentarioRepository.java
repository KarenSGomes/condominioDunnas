package com.dunnas.gerenciamento_chamados.repository;

import com.dunnas.gerenciamento_chamados.model.Comentario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ComentarioRepository extends JpaRepository<Comentario, Long> {
    // Caso precise buscar todos os comentários de um chamado específico ordenados por data
    List<Comentario> findByChamadoIdOrderByDataCriacaoDesc(Long chamadoId);
}
