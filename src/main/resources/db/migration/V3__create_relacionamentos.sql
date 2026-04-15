CREATE TABLE colaborador_categoria (
                                       usuario_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
                                       categoria_id BIGINT NOT NULL REFERENCES categorias(id) ON DELETE CASCADE,
                                       PRIMARY KEY (usuario_id, categoria_id)
);

CREATE TABLE morador_unidade (
                                 morador_id BIGINT NOT NULL REFERENCES usuarios(id) ON DELETE CASCADE,
                                 unidade_id BIGINT NOT NULL REFERENCES unidades(id) ON DELETE CASCADE,
                                 PRIMARY KEY (morador_id, unidade_id)
);