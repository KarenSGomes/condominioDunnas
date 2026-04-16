# Sistema de Gerenciamento de Chamados - Condomínio Dunnas

Este projeto consiste em uma plataforma para gestão de manutenções e ocorrências em condomínios, desenvolvida como parte do processo seletivo para Desenvolvimento de Software. O sistema permite que moradores solicitem suporte técnico enquanto a administração gerencia a infraestrutura e o fluxo de resolução de chamados.

## Decisões Técnicas e Estrutura

Para atender aos requisitos propostos, foi selecionada a **Opção 2** de stack tecnológica:

**Backend:** Java com Spring Boot, utilizando o padrão MVC
**Frontend:** Java Server Pages (JSP) para renderização dinâmica das interfaces
**Banco de Dados:** PostgreSQL para persistência de dados relacionais
**Versionamento de Banco:** Flyway, garantindo que a estrutura possa ser recriada do zero de forma consistente

## Implementação Técnica e Regras de Negócio

Esta seção detalha como as exigências do desafio foram traduzidas em lógica de programação dentro da stack Spring Boot.

### 1. Automação da Infraestrutura (`BlocoService`)

A geração automática de unidades foi implementada no método `salvarBloco` para garantir a consistência exigida:

* **Lógica de Identificação:** Utiliza um algoritmo baseado em laços de repetição que combina o nome do bloco com o cálculo `(andar * 100 + apartamento)` (ex: Bloco A-101, B-205).
* **Integridade Operacional:** O uso da anotação `@Transactional` garante que a criação do bloco e de todas as suas unidades ocorra como uma operação única, evitando inconsistências no banco de dados.

### 2. Gestão de Chamados e SLA (`ChamadoService`)

O ciclo de vida dos chamados foi desenvolvido para ser auditável e seguro:

* **Cálculo Automático de SLA:** Ao abrir um chamado, o sistema recupera o `prazoDias` da categoria selecionada e calcula a `dataLimite` somando esse valor à data de abertura.
* **Gestão de Arquivos:** Implementação de upload centralizado de mídias (imagens/PDF) com geração de nomes únicos via `UUID`, prevenindo sobreposição de arquivos no servidor.
* **Encerramento Auditável:** O método `concluirChamado` altera o status para "CONCLUIDO" e registra o `timestamp` exato da finalização.

### 3. Autenticação e Controle de Acesso (`LoginController`)

O controle de permissões é gerenciado através da sessão HTTP, utilizando a tipagem de objetos do Java:

* **Diferenciação por Herança:** O sistema identifica o perfil do usuário através do `dtype` no banco de dados, convertendo-o em instâncias específicas de `Administrador`, `Colaborador` ou `Morador`.
* **Escopo de Visualização:**

    * **Moradores:** Visualizam apenas chamados vinculados ao seu ID de usuário.
    * **Colaboradores:** O acesso é restrito aos chamados das categorias técnicas às quais eles foram vinculados pelo administrador.
    * **Administradores:** Possuem visão global de todos os chamados e gestão total da estrutura.

### 4. Segurança em Comentários e Interações (`ChamadoController`)

Para cumprir a regra de que moradores só comentam em seus próprios chamados:

* **Validação de Propriedade:** Antes de persistir um comentário, o controlador verifica se o `morador_id` do chamado corresponde ao ID do usuário presente na sessão.
* **Histórico de Interações:** Comentários são armazenados com autor e data, compondo uma linha do tempo imutável de suporte.

---

## Estrutura de Pastas do Projeto

A organização do projeto segue as convenções do Spring Boot e o padrão arquitetural MVC (Model-View-Controller):

```text
gerenciamento-chamados/
├── assets/             # Mídias e diagramas para documentação
├── src/main/java/com/dunnas/gerenciamento_chamados/
│   ├── config/         # Configurações gerais da aplicação
│   ├── controller/     # Controladores (Gerenciamento de rotas e perfis)
│   ├── model/          # Entidades (Administrador, Colaborador, Morador, etc.)
│   ├── repository/     # Interfaces de acesso ao banco de dados (Spring Data JPA)
│   └── service/        # Regras de negócio (SLA, geração de unidades, uploads)
├── src/main/resources/
│   ├── db.migration/   # Scripts de versionamento do banco de dados (Flyway)
│   ├── static.uploads/ # Armazenamento local de anexos dos chamados
│   └── application.yaml # Configurações de banco de dados e ambiente
└── src/main/webapp/WEB-INF/jsp/
    └── # Interfaces dinâmicas do sistema (Frontend)
```

---

## Modelagem de Dados (Diagrama Relacional)

Conforme solicitado no desafio, a estrutura do banco de dados foi modelada para suportar a herança de usuários e os relacionamentos entre unidades e chamados.

![diagramaCondDunnas.png](assets/diagramaCondDunnas.png)

O diagrama reflete uma arquitetura relacional projetada para garantir a integridade dos dados e o cumprimento das regras de negócio definidas no desafio:

* **Herança de Usuários (Tabela `USUARIO`)**
  Utiliza a estratégia de *Single Table Inheritance* (identificada pela coluna `dtype`), centralizando **Administradores**, **Colaboradores** e **Moradores** em uma única tabela, otimizando o controle de acesso e autenticação.

* **Hierarquia de Infraestrutura (`BLOCO` e `UNIDADE`)**
  Estabelece um relacionamento **1:N** entre **Blocos** e **Unidades**. A entidade **UNIDADE** armazena a informação do andar, permitindo a identificação única e automática do bloco, andar e apartamento.

* **Vínculos Flexíveis (Tabelas de Associação)**

* **`MORADOR_UNIDADE`**: Permite que um morador esteja vinculado a uma ou mais unidades.

* **`COLABORADOR_CATEGORIA`**: Define o escopo de atuação do colaborador, permitindo visualizar apenas os chamados relacionados às suas categorias técnicas.

* **Entidade Central (`CHAMADO`)**
  Conecta o **Morador** (solicitante), a **Unidade** (local da ocorrência) e a **Categoria** (que define o prazo de resolução/SLA).
  Também armazena os registros de tempo essenciais do sistema: data de abertura, prazo limite e data de finalização.

* **Histórico de Comunicação (`COMENTARIO`)**
  Relaciona-se com o **Chamado** e o **Usuário autor**, compondo o histórico de interações, respeitando as permissões de cada perfil.

