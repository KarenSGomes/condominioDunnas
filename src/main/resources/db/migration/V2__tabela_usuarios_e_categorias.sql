/* CREATE TABLE usuarios (
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
 */