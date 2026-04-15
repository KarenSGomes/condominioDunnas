package com.dunnas.gerenciamento_chamados.model;

import jakarta.persistence.*;

@Entity
@DiscriminatorValue("Administrador")
public class Administrador extends Usuario {
    // Admin geralmente não tem campos extras,
    // mas herda tudo de Usuario
}