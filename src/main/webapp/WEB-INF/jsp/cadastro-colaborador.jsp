<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>${colaborador.id == null ? 'Novo' : 'Editar'} Colaborador - Dunnas</title>
    <style>
        :root {
            --verde-dunnas: #2d5a27;
            --marrom-dunnas: #4b3621;
            --fundo: #f4f7f1;
            --danger: #c62828;
            --accent: #a5d6a7;
        }
        body { font-family: 'Segoe UI', sans-serif; background: var(--fundo); margin: 0; display: flex; }

        /* Sidebar Padronizada */
        .sidebar {
            width: 250px;
            background: var(--verde-dunnas);
            height: 100vh;
            color: white;
            padding: 20px;
            position: fixed;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            display: flex;
            flex-direction: column;
            z-index: 1000;
            box-sizing: border-box;
        }

        .sidebar h2 {
            font-size: 1.4em;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 15px;
            margin-bottom: 20px;
            letter-spacing: 1px;
        }

        /* Informações do Usuário Logado */
        .user-info {
            padding: 15px;
            background: rgba(255,255,255,0.1);
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9em;
            border-left: 4px solid var(--accent);
        }
        .user-info span { display: block; color: var(--accent); font-size: 0.75em; text-transform: uppercase; font-weight: bold; }
        .user-info strong { font-size: 1.1em; display: block; margin: 3px 0; overflow: hidden; text-overflow: ellipsis; }

        .sidebar a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 12px 15px;
            margin-bottom: 8px;
            border-radius: 5px;
            transition: 0.3s;
            font-size: 0.95em;
            font-weight: 500;
        }

        .sidebar a:hover {
            background: rgba(255,255,255,0.2);
            padding-left: 20px;
        }

        .btn-logout {
            background: var(--danger) !important;
            margin-top: auto;
            text-align: center;
            font-weight: bold !important;
        }

        /* Main Content */
        .main { margin-left: 290px; padding: 40px; width: calc(100% - 330px); }

        h1 { color: var(--marrom-dunnas); margin-bottom: 5px; }
        .subtitle { color: #666; margin-bottom: 25px; }

        /* Form Container */
        .form-container {
            background: white;
            padding: 35px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            max-width: 650px;
            border-top: 8px solid var(--verde-dunnas);
        }

        .form-group { margin-bottom: 22px; }
        label { display: block; font-weight: bold; color: var(--marrom-dunnas); margin-bottom: 8px; }
        input {
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px;
            box-sizing: border-box; font-size: 1em; transition: 0.3s;
        }
        input:focus { border-color: var(--verde-dunnas); outline: none; box-shadow: 0 0 5px rgba(45, 90, 39, 0.1); }

        /* Seleção de Categorias */
        .categories-container {
            background: #fdfdfd; padding: 15px; border: 1px solid #eee; border-radius: 8px;
            display: grid; grid-template-columns: 1fr 1fr; gap: 10px; max-height: 200px; overflow-y: auto;
        }
        .cat-item { display: flex; align-items: center; gap: 8px; font-weight: normal; cursor: pointer; padding: 5px; border-radius: 5px; transition: 0.2s; }
        .cat-item:hover { background: #f0f4ef; }
        .cat-item input { width: 18px; height: 18px; margin: 0; cursor: pointer; }

        /* Botões */
        .btn-container { display: flex; gap: 15px; margin-top: 35px; }
        .btn-save {
            flex: 2; padding: 14px; background: var(--verde-dunnas); color: white;
            border: none; border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 1.1em; transition: 0.3s;
        }
        .btn-save:hover { background: #1e3d1a; transform: translateY(-1px); }

        .btn-cancel {
            flex: 1; padding: 14px; background: #eee; text-align: center; color: #666;
            text-decoration: none; border-radius: 8px; font-weight: bold; transition: 0.3s;
        }
        .btn-cancel:hover { background: #e0e0e0; color: var(--danger); }

        .error-list { color: #d9534f; background: #f8d7da; padding: 15px; border-radius: 8px; margin-bottom: 25px; font-size: 0.9em; border-left: 5px solid #d9534f; }

        .btn-link { font-size: 0.85em; color: var(--verde-dunnas); text-decoration: none; font-weight: bold; }
        .btn-link:hover { text-decoration: underline; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>CONDOMÍNIO DUNNAS</h2>

    <div class="user-info">
        <span>Conectado como:</span>
        <strong>${usuarioLogado.nome}</strong>
        <span>Perfil: ${perfil}</span>
    </div>

    <c:choose>
        <c:when test="${perfil == 'ADMIN'}">
            <a href="/">🏠 Dashboard</a>
            <a href="/moradores">👤 Moradores</a>
            <a href="/colaboradores">👷 Colaboradores</a>
            <a href="/admins">🔑 Administradores</a>
            <a href="/chamados">📋 Chamados</a>
            <a href="/blocos">🏢 Blocos</a>
        </c:when>
        <c:when test="${perfil == 'COLABORADOR'}">
            <a href="/chamados">📋 Chamados no Escopo</a>
            <a href="/perfil">👤 Meus Dados</a>
        </c:when>
        <c:otherwise>
            <a href="/chamados/meus">📋 Meus Chamados</a>
            <a href="/chamados/novo">➕ Abrir Chamado</a>
        </c:otherwise>
    </c:choose>

    <a href="/logout" class="btn-logout"
       onclick="return confirm('Tem certeza que deseja sair do sistema Condomínio Dunnas?')">
        Sair do Sistema
    </a>
</div>

<div class="main">
    <h1>${colaborador.id == null ? ' Cadastrar Colaborador' : ' Editar Colaborador'}</h1>
    <p class="subtitle">Preencha as informações do prestador de serviço e suas especialidades.</p>

    <div class="form-container">
        <%-- Erros de validação --%>
        <form:errors path="*" element="div" cssClass="error-list" />

        <form:form action="/colaboradores/salvar" method="post" modelAttribute="colaborador">
            <form:hidden path="id" />

            <div class="form-group">
                <label>Nome Completo:</label>
                <form:input path="nome" required="true" placeholder="Ex: José Severino" />
            </div>

            <div class="form-group">
                <label>E-mail Corporativo:</label>
                <form:input path="email" type="email" required="true" placeholder="jose@dunnas.com" />
            </div>

            <div class="form-group">
                <label>Senha de Acesso:</label>
                <form:input path="senha" type="password" required="${colaborador.id == null}"
                            placeholder="${colaborador.id == null ? 'Digite a senha inicial' : 'Deixe vazio para manter a atual'}" />
            </div>

            <div class="form-group">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                    <label style="margin-bottom: 0;">Áreas de Atuação (Especialidades):</label>
                    <a href="/categorias/novo" class="btn-link">+ Nova Categoria</a>
                </div>

                <div class="categories-container">
                    <form:checkboxes path="categoriasPermitidas" items="${todasCategorias}"
                                     itemValue="id" itemLabel="nome" element="label class='cat-item'" />
                </div>
                <small style="color: #888;">Este colaborador verá apenas os chamados destas categorias.</small>
            </div>

            <div class="btn-container">
                <button type="submit" class="btn-save">
                        ${colaborador.id == null ? 'Salvar Cadastro' : 'Atualizar Dados'}
                </button>
                <a href="/colaboradores" class="btn-cancel">Cancelar</a>
            </div>
        </form:form>
    </div>
</div>

</body>
</html>