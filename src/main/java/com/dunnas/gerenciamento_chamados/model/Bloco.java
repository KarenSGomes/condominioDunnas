package com.dunnas.gerenciamento_chamados.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "blocos")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Bloco {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "A identificação do bloco é obrigatória")
    private String identificacao;

    @Positive(message = "A quantidade de andares deve ser maior que zero")
    @Column(name = "qtd_andares")
    private Integer qtdAndares;

    @Positive(message = "A quantidade de apartamentos por andar deve ser maior que zero")
    @Column(name = "aptos_por_andar")
    private Integer aptosPorAndar;

    // cascade ALL e orphanRemoval garantem que ao excluir um bloco,
    // todas as unidades (apartamentos) vinculadas sumam do banco automaticamente.
    @OneToMany(mappedBy = "bloco", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Unidade> unidades = new ArrayList<>();
}