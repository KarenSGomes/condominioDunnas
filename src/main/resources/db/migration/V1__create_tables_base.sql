CREATE TABLE blocos (
                        id BIGSERIAL PRIMARY KEY,
                        identificacao VARCHAR(100) NOT NULL,
                        qtd_andares INTEGER NOT NULL,
                        aptos_por_andar INTEGER NOT NULL
);

CREATE TABLE unidades (
                          id BIGSERIAL PRIMARY KEY,
                          identificacao VARCHAR(50) NOT NULL,
                          andar INTEGER,
                          bloco_id BIGINT NOT NULL REFERENCES blocos(id) ON DELETE CASCADE
);

CREATE TABLE usuarios (
                          id BIGSERIAL PRIMARY KEY,
                          dtype VARCHAR(31) NOT NULL, -- 'Administrador', 'Colaborador', 'Morador'
                          nome VARCHAR(100) NOT NULL,
                          email VARCHAR(100) NOT NULL UNIQUE,
                          senha VARCHAR(255) NOT NULL,
                          telefone VARCHAR(20)
);

CREATE TABLE categorias (
                            id BIGSERIAL PRIMARY KEY,
                            nome VARCHAR(50) NOT NULL UNIQUE,
                            prazo_dias INTEGER DEFAULT 3
);