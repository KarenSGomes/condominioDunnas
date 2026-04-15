<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Administradores - Dunnas</title>
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

        /* Botão Novo Padrão */
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

        /* Links de Ação */
        .btn-acao { text-decoration: none; font-weight: bold; font-size: 0.9em; margin-right: 15px; transition: 0.2s; }
        .btn-editar { color: var(--info-link); }
        .btn-editar:hover { text-decoration: underline; }
        .btn-excluir { color: var(--danger); }
        .btn-excluir:hover { text-decoration: underline; }

        /* Alertas */
        .alert { padding: 15px; margin-bottom: 25px; border-radius: 8px; font-weight: bold; background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
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
        <c:otherwise>
            <%-- Fallback caso outro perfil acesse --%>
            <a href="/">🏠 Voltar ao Início</a>
        </c:otherwise>
    </c:choose>

    <a href="/logout" class="btn-logout"
       onclick="return confirm('Tem certeza que deseja sair do sistema Condomínio Dunnas?')">
        Sair do Sistema
    </a>
</div>

<div class="main">
    <h1> Gestão de Administradores</h1>
    <p class="subtitle">Controle os usuários que possuem acesso total às configurações do sistema.</p>

    <c:if test="${not empty mensagemSucesso}">
        <div class="alert">✅ ${mensagemSucesso}</div>
    </c:if>

    <a href="/admins/novo" class="btn-add">➕ Cadastrar Novo Administrador</a>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Nome do Administrador</th>
                <th>E-mail de Acesso</th>
                <th>Ações</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${administradores}" var="adm">
                <tr>
                    <td><strong>${adm.nome}</strong></td>
                    <td><small style="color: var(--info-link);">${adm.email}</small></td>
                    <td>
                        <a href="/admins/editar/${adm.id}" class="btn-acao btn-editar">Editar</a>
                        <a href="/admins/excluir/${adm.id}" class="btn-acao btn-excluir"
                           onclick="return confirm('Excluir este administrador? Esta ação não pode ser desfeita.')">Excluir</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty administradores}">
            <div style="text-align: center; padding: 40px; color: #999; font-style: italic;">
                Nenhum administrador encontrado na base de dados.
            </div>
        </c:if>
    </div>
</div>

</body>
</html>