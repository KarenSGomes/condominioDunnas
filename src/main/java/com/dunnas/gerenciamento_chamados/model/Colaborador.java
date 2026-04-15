package com.dunnas.gerenciamento_chamados.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import java.util.List;

@Entity
@DiscriminatorValue("Colaborador")
@Data
@EqualsAndHashCode(callSuper = true)
public class Colaborador extends Usuario {
    @ManyToMany
    @JoinTable(
            name = "colaborador_categoria",
            joinColumns = @JoinColumn(name = "usuario_id"),
            inverseJoinColumns = @JoinColumn(name = "categoria_id")
    )
    private List<Categoria> categoriasPermitidas;
}