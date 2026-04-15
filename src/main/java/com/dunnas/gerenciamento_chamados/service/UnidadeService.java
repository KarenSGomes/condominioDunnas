package com.dunnas.gerenciamento_chamados.service;

import com.dunnas.gerenciamento_chamados.model.Unidade;
import com.dunnas.gerenciamento_chamados.repository.UnidadeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UnidadeService {
    private final UnidadeRepository unidadeRepository;

    public List<Unidade> listarTodas() {
        return unidadeRepository.findAll();
    }
}