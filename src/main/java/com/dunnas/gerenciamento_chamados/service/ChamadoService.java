package com.dunnas.gerenciamento_chamados.service;

import com.dunnas.gerenciamento_chamados.model.*;
import com.dunnas.gerenciamento_chamados.repository.ChamadoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ChamadoService {

    private final ChamadoRepository chamadoRepository;

    @Transactional
    public void salvar(Chamado chamado, MultipartFile file) throws IOException {
        if (chamado.getId() == null) {
            chamado.setStatus("ABERTO");
            chamado.setDataAbertura(LocalDateTime.now());

            if (chamado.getCategoria() != null && chamado.getCategoria().getPrazoDias() != null) {
                chamado.setDataLimite(chamado.getDataAbertura().plusDays(chamado.getCategoria().getPrazoDias()));
            }
        }

        // Lógica de Upload Centralizada
        if (file != null && !file.isEmpty()) {
            // Define o caminho absoluto para a pasta de uploads
            String rootPath = System.getProperty("user.dir");
            Path uploadPath = Paths.get(rootPath, "src/main/resources/static/uploads/");

            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            String extensao = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf("."));
            String fileName = UUID.randomUUID().toString() + extensao;

            Path filePath = uploadPath.resolve(fileName);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);

            chamado.setMidiaUrl(fileName);
        } else if (chamado.getId() != null) {
            // Se for edição e não enviou arquivo novo, recupera o nome do arquivo antigo do banco
            Chamado antigo = chamadoRepository.findById(chamado.getId()).orElse(null);
            if (antigo != null) chamado.setMidiaUrl(antigo.getMidiaUrl());
        }

        chamadoRepository.save(chamado);
    }

    @Transactional
    public void salvarComentario(Comentario comentario) {
        Chamado chamado = buscarPorId(comentario.getChamado().getId());
        comentario.setDataCriacao(LocalDateTime.now());
        chamado.getComentarios().add(comentario);
        chamadoRepository.save(chamado);
    }

    public List<Chamado> listarTodos() {
        return chamadoRepository.findAll();
    }

    public List<Chamado> listarPorEscopo(Usuario usuarioLogado) {
        if (usuarioLogado instanceof Administrador) return chamadoRepository.findAll();
        if (usuarioLogado instanceof Colaborador) {
            return chamadoRepository.findByCategoriaIn(((Colaborador) usuarioLogado).getCategoriasPermitidas());
        }
        if (usuarioLogado instanceof Morador) return chamadoRepository.findByMoradorId(usuarioLogado.getId());
        return List.of();
    }

    public Chamado buscarPorId(Long id) {
        return chamadoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Chamado não encontrado: " + id));
    }

    @Transactional
    public void iniciarAtendimento(Long id) {
        Chamado chamado = buscarPorId(id);
        if ("ABERTO".equalsIgnoreCase(chamado.getStatus())) {
            chamado.setStatus("EM_ATENDIMENTO");
            chamadoRepository.save(chamado);
        }
    }

    @Transactional
    public void concluirChamado(Long id) {
        Chamado chamado = buscarPorId(id);
        chamado.setStatus("CONCLUIDO");
        chamado.setDataFinalizacao(LocalDateTime.now());
        chamadoRepository.save(chamado);
    }

    @Transactional
    public void excluir(Long id) {
        chamadoRepository.deleteById(id);
    }
}