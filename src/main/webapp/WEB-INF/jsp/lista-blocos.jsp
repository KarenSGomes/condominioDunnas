<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Blocos - Dunnas</title>
    <style>
        :root {
            --verde-dunnas: #2d5a27;
            --marrom-dunnas: #4b3621;
            --fundo: #f4f7f1;
            --danger: #c62828;
            --accent: #a5d6a7;
            --info: #1976d2;
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
        .main { margin-left: 290px; padding: 40px; width: calc(100% - 330px); box-sizing: border-box; }

        h1 { color: var(--marrom-dunnas); margin: 0; font-size: 1.8em; }
        .subtitle { color: #666; margin-bottom: 25px; }

        /* Botão Novo Padrão */
        .btn-add {
            background-color: var(--verde-dunnas);
            color: white;
            text-decoration: none;
            padding: 12px 20px;
            border-radius: 5px;
            font-weight: bold;
            transition: 0.3s;
            display: inline-block;
            margin-bottom: 25px;
        }
        .btn-add:hover { background: #1e3d1a; transform: translateY(-1px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }

        /* Tabela */
        .table-container { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; color: var(--marrom-dunnas); padding: 15px; text-align: left; border-bottom: 2px solid #eee; font-size: 0.85em; text-transform: uppercase; font-weight: bold; }
        td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; font-size: 0.95em; color: #333; }

        /* Ações */
        .action-links { display: flex; gap: 15px; align-items: center; }
        .btn-edit { text-decoration: none; color: var(--info); font-size: 1.2em; transition: 0.2s; }
        .btn-edit:hover { transform: scale(1.2); }
        .btn-del { text-decoration: none; color: var(--danger); font-size: 1.2em; transition: 0.2s; cursor: pointer; border: none; background: none; padding: 0; }
        .btn-del:hover { transform: scale(1.2); }

        /* Alertas */
        .alert { padding: 15px; border-radius: 8px; margin-bottom: 25px; font-weight: bold; border-left: 5px solid; animation: fadeIn 0.4s; }
        .alert-success { background-color: #d4edda; color: #155724; border-left-color: #2e7d32; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border-left-color: var(--danger); }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-5px); }
            to { opacity: 1; transform: translateY(0); }
        }
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
    <h1>🏢 Gestão de Blocos e Unidades</h1>
    <p class="subtitle">Administre os blocos e as unidades habitacionais geradas automaticamente.</p>

    <%-- Mensagens de Feedback --%>
    <c:if test="${not empty mensagemSucesso}">
        <div class="alert alert-success">✅ ${mensagemSucesso}</div>
    </c:if>

    <c:if test="${not empty mensagemErro}">
        <div class="alert alert-danger">❌ ${mensagemErro}</div>
    </c:if>

    <a href="/blocos/novo" class="btn-add">➕ Cadastrar Novo Bloco</a>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Identificação</th>
                <th>Andares</th>
                <th>Aptos/Andar</th>
                <th>Total Unidades</th>
                <th style="text-align: center;">Ações</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${blocos}" var="b">
                <tr>
                    <td><strong>${b.identificacao}</strong></td>
                    <td>${b.qtdAndares}</td>
                    <td>${b.aptosPorAndar}</td>
                    <td style="color: var(--verde-dunnas); font-weight: bold;">
                            ${b.qtdAndares * b.aptosPorAndar}
                    </td>
                    <td class="action-links" style="justify-content: center;">
                            <%-- Botão Editar --%>
                        <a href="/blocos/editar/${b.id}" class="btn-edit" title="Editar Nome do Bloco">✏️</a>

                            <%-- Botão Excluir --%>
                        <a href="/blocos/excluir/${b.id}" class="btn-del"
                           title="Excluir Bloco"
                           onclick="return confirm('ATENÇÃO: Isso excluirá o ${b.identificacao} e TODAS as suas unidades. Deseja continuar?')">🗑️</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty blocos}">
            <div style="text-align: center; padding: 40px; color: #999; font-style: italic;">
                Nenhum bloco cadastrado no momento.
            </div>
        </c:if>
    </div>
</div>

</body>
</html>