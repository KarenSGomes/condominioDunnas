package com.dunnas.gerenciamento_chamados.service;

import com.dunnas.gerenciamento_chamados.model.Bloco;
import com.dunnas.gerenciamento_chamados.model.Unidade;
import com.dunnas.gerenciamento_chamados.repository.BlocoRepository;
import com.dunnas.gerenciamento_chamados.repository.UnidadeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class BlocoService {

    private final BlocoRepository blocoRepository;
    private final UnidadeRepository unidadeRepository;

    /**
     * Lista todos os blocos cadastrados.
     */
    public List<Bloco> listarTodos() {
        return blocoRepository.findAll();
    }

    /**
     * Salva o bloco e gera as unidades automaticamente se for um novo registro.
     */
    @Transactional
    public Bloco salvarBloco(Bloco bloco) {
        // Validação de segurança extra para números positivos
        if (bloco.getQtdAndares() <= 0 || bloco.getAptosPorAndar() <= 0) {
            throw new RuntimeException("Quantidade de andares e apartamentos deve ser maior que zero.");
        }

        boolean ehNovoBloco = (bloco.getId() == null);
        Bloco blocoSalvo = blocoRepository.save(bloco);

        // Só gera unidades automaticamente se for a primeira vez que salvamos o bloco
        if (ehNovoBloco) {
            for (int andar = 1; andar <= bloco.getQtdAndares(); andar++) {
                for (int apto = 1; apto <= bloco.getAptosPorAndar(); apto++) {
                    Unidade unidade = new Unidade();

                    // Formato: Nome do Bloco + Andar + Número do Apto (ex: Bloco A-101)
                    String identificacao = bloco.getIdentificacao() + "-" + (andar * 100 + apto);

                    unidade.setIdentificacao(identificacao);
                    unidade.setBloco(blocoSalvo);
                    unidadeRepository.save(unidade);
                }
            }
        }

        return blocoSalvo;
    }

    /**
     * Busca um bloco por ID.
     */
    public Bloco buscarPorId(Long id) {
        return blocoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Bloco não encontrado com o ID: " + id));
    }

    /**
     * Exclui um bloco e, consequentemente, suas unidades (devido ao CascadeType.ALL).
     */
    @Transactional
    public void excluir(Long id) {
        if (!blocoRepository.existsById(id)) {
            throw new RuntimeException("Não foi possível excluir: Bloco inexistente.");
        }
        blocoRepository.deleteById(id);
    }
}