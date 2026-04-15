package com.dunnas.gerenciamento_chamados.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import java.util.ArrayList;
import java.util.List;

@Entity
@DiscriminatorValue("Morador")
@Data
@EqualsAndHashCode(callSuper = true)
@ToString(callSuper = true) // Útil para debug ver os campos de Usuario também
public class Morador extends Usuario {

    private String cpf;

    private String telefone;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "morador_unidade", // Nome da tabela de ligação no banco
            joinColumns = @JoinColumn(name = "morador_id"),
            inverseJoinColumns = @JoinColumn(name = "unidade_id")
    )
    private List<Unidade> unidades = new ArrayList<>();

    /**
     * Helper method para facilitar a adição de unidades e manter a consistência
     */
    public void adicionarUnidade(Unidade unidade) {
        this.unidades.add(unidade);
    }
}