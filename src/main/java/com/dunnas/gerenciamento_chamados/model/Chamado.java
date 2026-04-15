package com.dunnas.gerenciamento_chamados.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "chamados")
@Data
public class Chamado {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String titulo;

    @Column(columnDefinition = "TEXT")
    private String descricao;

    private String status = "ABERTO";

    private LocalDateTime dataAbertura = LocalDateTime.now();

    private LocalDateTime dataLimite;

    private LocalDateTime dataFinalizacao;

    private String midiaUrl;

    @ManyToOne
    @JoinColumn(name = "morador_id", nullable = false)
    private Morador morador;

    @ManyToOne
    @JoinColumn(name = "unidade_id")
    private Unidade unidade;

    @ManyToOne
    @JoinColumn(name = "categoria_id")
    private Categoria categoria;

    // --- O QUE ESTAVA FALTANDO AQUI: ---
    @OneToMany(mappedBy = "chamado", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("dataCriacao DESC")
    private List<Comentario> comentarios = new ArrayList<>();
}