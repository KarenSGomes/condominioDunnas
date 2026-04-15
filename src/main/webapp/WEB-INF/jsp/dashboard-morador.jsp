<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Morador | Dunnas</title>
    <style>
        :root {
            --verde-dunnas: #2d5a27;
            --marrom-dunnas: #4b3621;
            --fundo: #f4f7f1;
            --danger: #c62828;
            --accent: #a5d6a7;
            --azul-status: #2196f3;
            --laranja-status: #ff9800;
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

        .welcome-msg { color: var(--marrom-dunnas); margin: 0; font-size: 1.8em; }
        .subtitle { color: #666; margin-bottom: 30px; }

        /* Cards de Status */
        .cards-container { display: flex; gap: 20px; margin-bottom: 30px; }
        .card-status {
            padding: 25px; flex: 1; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            display: flex; flex-direction: column; justify-content: center; background: white;
            border-top: 5px solid var(--verde-dunnas);
        }
        .card-status h3 { margin: 0; font-size: 0.85em; text-transform: uppercase; letter-spacing: 1px; }
        .card-status p { margin: 10px 0 0; font-size: 2.5em; font-weight: bold; color: var(--marrom-dunnas); }

        /* Tabela e Listagem */
        .table-container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .header-tabela { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid var(--verde-dunnas); padding-bottom: 10px; }

        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 15px; border-bottom: 2px solid #eee; color: var(--marrom-dunnas); font-size: 0.85em; text-transform: uppercase; font-weight: bold; }
        td { padding: 15px; border-bottom: 1px solid #f9f9f9; color: #333; font-size: 0.95em; }

        /* Badges de Status */
        .badge { padding: 6px 12px; border-radius: 20px; font-size: 0.75em; font-weight: bold; text-transform: uppercase; }
        .badge-aberto { background: #fff3cd; color: #856404; }
        .badge-em_atendimento { background: #d1ecf1; color: #0c5460; }
        .badge-finalizado { background: #e8f5e9; color: #155724; }

        .btn-novo {
            background: var(--verde-dunnas); color: white; padding: 12px 24px;
            border-radius: 8px; text-decoration: none; font-weight: bold; transition: 0.3s;
            box-shadow: 0 4px 6px rgba(45, 90, 39, 0.2);
        }
        .btn-novo:hover { background: #1e3d1a; transform: translateY(-2px); }

        /* Alertas de Feedback */
        .alert { padding: 15px; border-radius: 8px; margin-bottom: 25px; font-weight: bold; border-left: 5px solid; }
        .alert-success { background: #d4edda; color: #155724; border-left-color: #2e7d32; }
        .alert-danger { background: #f8d7da; color: #721c24; border-left-color: var(--danger); }
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

    <a href="/chamados/dashboard-morador">🏠 Dashboard</a>
    <a href="/chamados/novo">➕ Abrir Chamado</a>
    <a href="/chamados">📋 Meus Chamados</a>

    <a href="/logout" class="btn-logout"
       onclick="return confirm('Tem certeza que deseja sair do sistema Condomínio Dunnas?')">
        Sair do Sistema
    </a>
</div>

<div class="main">
    <h1 class="welcome-msg">Bem-vindo(a), ${usuarioLogado.nome}! </h1>
    <p class="subtitle">Acompanhe suas solicitações e abra novos chamados para sua unidade.</p>

    <%-- BLOCO DE MENSAGENS DE FEEDBACK --%>
    <c:if test="${not empty mensagemSucesso}">
        <div class="alert alert-success">✅ ${mensagemSucesso}</div>
    </c:if>

    <c:if test="${not empty mensagemErro}">
        <div class="alert alert-danger">❌ ${mensagemErro}</div>
    </c:if>

    <%-- CARDS DE STATUS --%>
    <div class="cards-container">
        <div class="card-status" style="border-top-color: var(--azul-status);">
            <h3 style="color: var(--azul-status);">🆕 Em Aberto</h3>
            <p>${qtdAbertos}</p>
        </div>
        <div class="card-status" style="border-top-color: var(--laranja-status);">
            <h3 style="color: var(--laranja-status);">⏳ Em Atendimento</h3>
            <p>${qtdAndamento}</p>
        </div>
    </div>

    <%-- TABELA DE RECENTES --%>
    <div class="table-container">
        <div class="header-tabela">
            <h2 style="color: var(--marrom-dunnas); margin: 0; font-size: 1.3em;">📋 Histórico Recente</h2>
            <a href="/chamados/novo" class="btn-novo">+ Novo Chamado</a>
        </div>

        <table>
            <thead>
            <tr>
                <th>Título</th>
                <th>Unidade</th>
                <th>Status</th>
                <th>Data de Abertura</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${meusChamados}" var="chamado">
                <tr>
                    <td><strong>${chamado.titulo}</strong></td>
                    <td><span style="color: var(--verde-dunnas); font-weight: 600;">${chamado.unidade.identificacao}</span></td>
                    <td>
                        <span class="badge badge-${chamado.status.toLowerCase()}">${chamado.status}</span>
                    </td>
                    <td>
                        <fmt:parseDate value="${chamado.dataAbertura}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty meusChamados}">
                <tr>
                    <td colspan="4" style="text-align: center; padding: 40px; color: #999; font-style: italic;">
                        Você ainda não possui chamados registrados. Clique em "+ Novo Chamado" para começar.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>