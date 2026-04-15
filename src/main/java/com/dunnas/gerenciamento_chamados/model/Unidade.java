package com.dunnas.gerenciamento_chamados.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "unidades")
@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
public class Unidade {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String identificacao;

    @ManyToOne
    @JoinColumn(name = "bloco_id")
    private Bloco bloco;
}