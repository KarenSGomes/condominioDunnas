package com.dunnas.gerenciamento_chamados.repository;

import com.dunnas.gerenciamento_chamados.model.Chamado;
import com.dunnas.gerenciamento_chamados.model.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface ChamadoRepository extends JpaRepository<Chamado, Long> {

    // O Spring Data JPA entende esse nome e cria o SQL automaticamente!
    List<Chamado> findByCategoriaIn(List<Categoria> categorias);
    List<Chamado> findByMoradorId(Long moradorId);
}