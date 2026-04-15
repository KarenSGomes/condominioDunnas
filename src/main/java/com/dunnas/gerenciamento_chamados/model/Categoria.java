package com.dunnas.gerenciamento_chamados.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import lombok.Data;

@Entity
@Table(name = "categorias")
@Data
public class Categoria {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "O nome da categoria é obrigatório")
    @Column(nullable = false, unique = true)
    private String nome;

    @Positive(message = "O prazo em dias deve ser um número maior que zero")
    @Column(nullable = false)
    private Integer prazoDias;

    // Se você não for usar o campo 'prazoEstimado' no banco,
    // recomendo remover para manter o modelo limpo.
    // Mas, caso precise dele para outra lógica:
    @Positive(message = "O prazo estimado deve ser um número positivo")
    private Integer prazoEstimado;
}