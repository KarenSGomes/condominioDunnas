package com.dunnas.gerenciamento_chamados.service;
import com.dunnas.gerenciamento_chamados.model.Comentario;
import com.dunnas.gerenciamento_chamados.repository.ComentarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ComentarioService {

    private final ComentarioRepository comentarioRepository;

    @Transactional
    public void salvar(Comentario comentario) {
        // Garante que a data de criação seja o momento exato do envio
        if (comentario.getDataCriacao() == null) {
            comentario.setDataCriacao(LocalDateTime.now());
        }
        comentarioRepository.save(comentario);
    }

    public List<Comentario> buscarPorChamado(Long chamadoId) {
        return comentarioRepository.findByChamadoIdOrderByDataCriacaoDesc(chamadoId);
    }
}