<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Moradores - Dunnas</title>
    <style>
        :root {
            --verde-dunnas: #2d5a27;
            --marrom-dunnas: #4b3621;
            --fundo: #f4f7f1;
            --danger: #c62828;
            --accent: #a5d6a7;
            --info-link: #007bff;
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

        .btn-add {
            background: var(--verde-dunnas);
            color: white;
            padding: 12px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-bottom: 25px;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-add:hover { background: #1e3d1a; transform: translateY(-1px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }

        /* Tabela */
        .table-container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        table { border-collapse: collapse; width: 100%; }
        th { background-color: #f8f9fa; color: var(--marrom-dunnas); padding: 15px; text-align: left; border-bottom: 2px solid #eee; font-weight: bold; text-transform: uppercase; font-size: 0.85em; }
        td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; font-size: 0.95em; vertical-align: middle; }

        .unit-badge {
            background: #e7f3ff; color: #0056b3; padding: 4px 12px; border-radius: 20px;
            font-size: 0.8em; margin-right: 5px; display: inline-block; border: 1px solid #b3d7ff;
            margin-bottom: 4px; font-weight: 600;
        }

        /* Links de Ação */
        .btn-acao { text-decoration: none; font-weight: bold; font-size: 0.9em; margin-right: 15px; transition: 0.2s; }
        .btn-editar { color: var(--info-link); }
        .btn-editar:hover { text-decoration: underline; }
        .btn-excluir { color: var(--danger); }
        .btn-excluir:hover { text-decoration: underline; }

        /* Alertas */
        .alert { padding: 15px; margin-bottom: 25px; border-radius: 8px; font-weight: bold; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
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
    <h1> Gestão de Moradores</h1>
    <p class="subtitle">Controle de moradores cadastrados e suas respectivas unidades.</p>

    <%-- Mensagens de Feedback --%>
    <c:if test="${not empty mensagemSucesso}">
        <div class="alert alert-success">✅ ${mensagemSucesso}</div>
    </c:if>
    <c:if test="${not empty mensagemErro}">
        <div class="alert alert-error">❌ ${mensagemErro}</div>
    </c:if>

    <a href="/moradores/novo" class="btn-add">➕ Cadastrar Novo Morador</a>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Morador</th>
                <th>CPF / Telefone</th>
                <th>Unidades Vinculadas</th>
                <th>Ações</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${moradores}" var="m">
                <tr>
                    <td>
                        <strong>${m.nome}</strong><br>
                        <small style="color: var(--info-link);">${m.email}</small>
                    </td>
                    <td>
                        <span>${m.cpf}</span><br>
                        <small style="color: #666;">${m.telefone}</small>
                    </td>
                    <td>
                        <c:forEach items="${m.unidades}" var="uni">
                            <span class="unit-badge">${uni.identificacao}</span>
                        </c:forEach>
                        <c:if test="${empty m.unidades}">
                            <span style="color: #bbb; font-style: italic; font-size: 0.9em;">Sem vínculo</span>
                        </c:if>
                    </td>
                    <td>
                        <a href="/moradores/editar/${m.id}" class="btn-acao btn-editar">Editar</a>
                        <a href="/moradores/excluir/${m.id}" class="btn-acao btn-excluir"
                           onclick="return confirm('Excluir este morador? Isso removerá o acesso dele ao sistema.')">Excluir</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty moradores}">
            <div style="text-align: center; padding: 40px; color: #999;">
                <p>Nenhum morador encontrado na base de dados.</p>
            </div>
        </c:if>
    </div>
</div>

</body>
</html>