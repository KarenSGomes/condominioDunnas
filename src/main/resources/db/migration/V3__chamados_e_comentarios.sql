CREATE TABLE chamados (
                          id BIGSERIAL PRIMARY KEY,
                          titulo VARCHAR(100) NOT NULL,
                          descricao TEXT NOT NULL,
                          status VARCHAR(30) NOT NULL, -- ABERTO, EM_ANDAMENTO, CONCLUIDO
                          data_abertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          data_limite TIMESTAMP, -- Calculado via Java com base no prazo_dias da categoria
                          data_finalizacao TIMESTAMP,
                          midia_url VARCHAR(255),
                          morador_id BIGINT NOT NULL REFERENCES usuarios(id),
                          unidade_id BIGINT NOT NULL REFERENCES unidades(id),
                          categoria_id BIGINT NOT NULL REFERENCES categorias(id)
);

CREATE TABLE comentarios (
                             id BIGSERIAL PRIMARY KEY,
                             chamado_id BIGINT NOT NULL REFERENCES chamados(id) ON DELETE CASCADE,
                             autor_id BIGINT NOT NULL REFERENCES usuarios(id),
                             texto TEXT NOT NULL,
                             data_criacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);