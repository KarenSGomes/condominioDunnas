## 🏗️ Módulo: Gerenciamento de Infraestrutura (Blocos e Unidades)

### 1. Descrição da Funcionalidade
Implementação da lógica de cadastro de blocos residenciais com **geração automatizada de unidades**. O sistema elimina a necessidade de cadastro manual de cada apartamento, calculando as unidades com base na estrutura física do prédio.

### 2. Regra de Negócio (Geração Automática)
Ao salvar um novo Bloco, o sistema executa um algoritmo que combina o número do andar com o índice do apartamento.
* **Input:** `identificacao: "Bloco A"`, `qtdAndares: 3`, `aptosPorAndar: 2`.
* **Processamento:** * O sistema itera sobre os andares ($1$ a $n$) e sobre os apartamentos por andar ($1$ a $m$).
    * A identificação da unidade é gerada seguindo o padrão: `{Nome do Bloco}-{Andar}{Número do Apto}`.
* **Output esperado:** Unidades A-101, A-102, A-201, A-202, A-301, A-302.

### 3. Modelo de Dados (ERD)
A estrutura foi desenhada para garantir a integridade referencial utilizando **PostgreSQL**:

| Tabela | Coluna | Tipo | Descrição |
| :--- | :--- | :--- | :--- |
| **blocos** | `id` | BIGINT (PK) | Identificador único do bloco (Auto-incremento). |
| | `identificacao` | VARCHAR(100) | Nome ou letra do bloco. |
| | `qtd_andares` | INTEGER | Total de pavimentos. |
| | `aptos_por_andar`| INTEGER | Quantidade de unidades por nível. |
| **unidades**| `id` | BIGINT (PK) | Identificador único da unidade. |
| | `identificacao` | VARCHAR(50) | Nome gerado (ex: Bloco A-101). |
| | `bloco_id` | BIGINT (FK) | Chave estrangeira ligando à tabela `blocos`. |

### 4. Tecnologias Utilizadas
* **Spring Data JPA:** Abstração da camada de persistência.
* **Hibernate:** Mapeamento Objeto-Relacional (ORM) e validação de schema.
* **Flyway:** Versionamento de banco de dados para garantir que a estrutura seja replicada corretamente em qualquer ambiente.
* **Docker Compose:** Orquestração do banco de dados PostgreSQL isolado.

---

### 💡 Dica de "ouro" para a entrevista:
Se eles perguntarem por que você usou `@Transactional` no `Service`, você pode dizer:
> *"Usei para garantir a atomicidade. Ou o bloco e todas as suas unidades são salvos com sucesso, ou nada é salvo. Isso evita que o banco fique com um Bloco cadastrado mas sem os seus apartamentos caso ocorra uma falha no meio do processo."*

Essa documentação está clara para você colocar no seu **GitHub** ou no arquivo final? Se sim, podemos seguir para as dependências do JSP!