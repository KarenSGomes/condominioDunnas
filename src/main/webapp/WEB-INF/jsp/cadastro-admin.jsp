<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>${admin.id == null ? 'Novo' : 'Editar'} Admin - Dunnas</title>
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
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            z-index: 1000;
            box-sizing: border-box;
        }

        .sidebar h2 {
            font-size: 1.4em;
            text-align: center;
            margin-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 15px;
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

        .sidebar a:hover { background: rgba(255,255,255,0.2); padding-left: 20px; }

        .btn-logout {
            background: var(--danger) !important;
            text-align: center;
            margin-top: auto;
            font-weight: bold !important;
        }

        /* Main Content */
        .main { margin-left: 290px; padding: 40px; width: calc(100% - 330px); display: flex; flex-direction: column; align-items: flex-start; }

        h1 { color: var(--marrom-dunnas); margin-bottom: 25px; }

        .form-container {
            background: white;
            padding: 35px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 500px;
            border-top: 5px solid var(--marrom-dunnas);
        }

        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: bold; color: var(--marrom-dunnas); margin-bottom: 8px; }
        input { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; font-size: 1em; }
        input:focus { border-color: var(--verde-dunnas); outline: none; box-shadow: 0 0 5px rgba(45,90,39,0.2); }

        .btn-submit {
            width: 100%;
            padding: 14px;
            background: var(--verde-dunnas);
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            font-size: 1.1em;
            transition: 0.3s;
        }
        .btn-submit:hover { background: #1e3d1a; transform: translateY(-1px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }

        .btn-cancel {
            display: block;
            text-align: center;
            margin-top: 15px;
            width: 100%;
            color: #666;
            text-decoration: none;
            font-size: 0.95em;
            font-weight: 500;
        }
        .btn-cancel:hover { color: var(--danger); text-decoration: underline; }
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
    <h1>${admin.id == null ? '➕ Novo Administrador' : ' Editar Administrador'}</h1>

    <div class="form-container">
        <form:form action="/admins/salvar" method="post" modelAttribute="admin">
            <form:hidden path="id" />

            <div class="form-group">
                <label>Nome do Administrador:</label>
                <form:input path="nome" required="true" placeholder="Ex: Marília Silva" />
            </div>

            <div class="form-group">
                <label>E-mail de Acesso:</label>
                <form:input path="email" type="email" required="true" placeholder="admin@dunnas.com" />
            </div>

            <div class="form-group">
                <label>Senha:</label>
                <form:input path="senha" type="password" required="${admin.id == null}"
                            placeholder="${admin.id == null ? 'Digite a senha' : 'Deixe vazio para não alterar'}" />
            </div>

            <button type="submit" class="btn-submit">Finalizar Cadastro</button>
            <a href="/admins" class="btn-cancel">Voltar para listagem</a>
        </form:form>
    </div>
</div>

</body>
</html>