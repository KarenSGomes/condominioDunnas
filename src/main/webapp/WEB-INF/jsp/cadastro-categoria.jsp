<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Nova Categoria - Dunnas</title>
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
        .main { margin-left: 290px; padding: 40px; width: calc(100% - 330px); display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 80vh; }

        .form-container {
            background: white;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 450px;
            border-top: 8px solid var(--marrom-dunnas);
        }

        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: bold; color: var(--marrom-dunnas); margin-bottom: 8px; }
        input {
            width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px;
            box-sizing: border-box; font-size: 1em; transition: 0.3s;
        }
        input:focus { border-color: var(--verde-dunnas); outline: none; box-shadow: 0 0 5px rgba(45, 90, 39, 0.1); }

        .btn-submit {
            background: var(--verde-dunnas); color: white; border: none; padding: 14px;
            border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 1.1em; width: 100%; transition: 0.3s;
        }
        .btn-submit:hover { background: #1e3d1a; transform: translateY(-1px); }

        .btn-cancel { display: block; text-align: center; margin-top: 15px; color: #666; text-decoration: none; font-size: 0.95em; font-weight: 500; }
        .btn-cancel:hover { color: var(--danger); text-decoration: underline; }

        .alert-error { background: #f8d7da; color: #721c24; padding: 12px; border-radius: 8px; margin-bottom: 20px; font-size: 0.9em; border-left: 4px solid var(--danger); font-weight: bold; }
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

    <a href="/">🏠 Dashboard</a>
    <a href="/moradores">👤 Moradores</a>
    <a href="/colaboradores">👷 Colaboradores</a>
    <a href="/admins">🔑 Administradores</a>
    <a href="/chamados">📋 Chamados</a>
    <a href="/blocos">🏢 Blocos</a>

    <a href="/logout" class="btn-logout"
       onclick="return confirm('Tem certeza que deseja sair do sistema Condomínio Dunnas?')">
        Sair do Sistema
    </a>
</div>

<div class="main">
    <div class="form-container">
        <h2 style="color: var(--marrom-dunnas); margin-top: 0; text-align: center;">🏷️ Nova Categoria</h2>
        <p style="color: #777; font-size: 0.9em; text-align: center; margin-bottom: 25px;">Defina especialidades para os colaboradores.</p>

        <%-- Alerta de erro caso o Controller recuse um número negativo --%>
        <c:if test="${not empty mensagemErro}">
            <div class="alert-error">${mensagemErro}</div>
        </c:if>

        <form:form action="/categorias/salvar" method="post" modelAttribute="categoria">

            <div class="form-group">
                <label>Nome da Especialidade:</label>
                <form:input path="nome" required="true" placeholder="Ex: Hidráulica, Pintura..." />
            </div>

            <div class="form-group">
                <label>Prazo de Resolução (SLA em dias):</label>
                    <%-- Atributo min="1" garante que o navegador não aceite negativos nem zero --%>
                <form:input path="prazoDias" type="number" required="true" min="1" step="1" placeholder="Ex: 3" />
                <small style="color: #999; font-size: 0.8em;">* Somente números positivos.</small>
            </div>

            <button type="submit" class="btn-submit">Cadastrar Categoria</button>
            <a href="/colaboradores/novo" class="btn-cancel">Voltar para Colaboradores</a>
        </form:form>
    </div>
</div>

</body>
</html>