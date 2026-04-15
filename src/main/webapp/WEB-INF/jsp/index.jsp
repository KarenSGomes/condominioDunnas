<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Condomínio Dunnas - Dashboard</title>
    <style>
        :root {
            --verde-dunnas: #2d5a27;
            --marrom-dunnas: #4b3621;
            --fundo: #f4f7f1;
            --danger: #c62828;
            --accent: #a5d6a7;
        }
        body { font-family: 'Segoe UI', sans-serif; background: var(--fundo); margin: 0; display: flex; }

        /* Sidebar */
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
        }

        .sidebar h2 {
            color: #ffffff;
            font-size: 1.4em;
            margin-bottom: 20px;
            text-align: center;
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

        /* Cards de Estatísticas */
        .dashboard-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-left: 5px solid var(--verde-dunnas); }
        .card h3 { margin: 0; color: #666; font-size: 0.8em; text-transform: uppercase; letter-spacing: 1px; }
        .card p { margin: 10px 0 0; font-size: 2.2em; font-weight: bold; color: var(--marrom-dunnas); }

        /* Tabela */
        .section-title { color: var(--marrom-dunnas); border-bottom: 2px solid var(--verde-dunnas); padding-bottom: 10px; margin-bottom: 20px; font-weight: 600; }
        .table-container { background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; color: var(--marrom-dunnas); padding: 15px; text-align: left; border-bottom: 2px solid #eee; }
        td { padding: 15px; border-bottom: 1px solid #eee; color: #333; }
        .status-badge { padding: 5px 12px; border-radius: 20px; font-size: 0.8em; font-weight: bold; background: #e8f5e9; color: #2d5a27; }
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
        <%-- Visão do Administrador --%>
        <c:when test="${perfil == 'ADMIN'}">
            <a href="/">🏠 Dashboard</a>
            <a href="/moradores">👤 Moradores</a>
            <a href="/colaboradores">👷 Colaboradores</a>
            <a href="/admins">🔑 Administradores</a> <%-- NOVO LINK --%>
            <a href="/chamados">📋 Chamados</a>
            <a href="/blocos">🏢 Blocos</a>
        </c:when>

        <%-- Visão do Colaborador --%>
        <c:when test="${perfil == 'COLABORADOR'}">
            <a href="/chamados">📋 Chamados no Escopo</a>
            <a href="/perfil">👤 Meus Dados</a>
        </c:when>

        <%-- Visão do Morador --%>
        <c:when test="${perfil == 'MORADOR'}">
            <a href="/chamados/meus">📋 Meus Chamados</a>
            <a href="/chamados/novo">➕ Abrir Chamado</a>
        </c:when>
    </c:choose>

    <a href="/logout" class="btn-logout"
       onclick="return confirm('Tem certeza que deseja sair do sistema Condomínio Dunnas?')">
         Sair do Sistema
    </a>

</div>

<div class="main">
    <h1 class="section-title">Bem-vinda(o), ${usuarioLogado.nome}! </h1>

    <c:choose>
        <c:when test="${perfil == 'ADMIN'}">
            <div class="dashboard-cards">
                <div class="card">
                    <h3>Total de Moradores</h3>
                    <p>${totalMoradores}</p>
                </div>
                <div class="card">
                    <h3>Colaboradores</h3>
                    <p>${totalColaboradores}</p>
                </div>
                <div class="card">
                    <h3>Chamados Abertos</h3>
                    <p>${totalChamadosAbertos}</p>
                </div>
                <div class="card">
                    <h3>SLA Crítico</h3>
                    <p style="color: var(--danger)">${chamadosAtrasados}</p>
                </div>
            </div>

            <h2 class="section-title">Últimos Chamados Registrados</h2>
            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>Título</th>
                        <th>Morador</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${chamadosRecentes}" var="c">
                        <tr>
                            <td><strong>${c.titulo}</strong></td>
                            <td>${c.morador.nome}</td>
                            <td><span class="status-badge">${c.status}</span></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty chamadosRecentes}">
                        <tr>
                            <td colspan="3" style="text-align: center; color: #999; padding: 30px;">
                                Nenhum chamado registrado até o momento.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </c:when>

        <c:otherwise>
            <div style="background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-top: 5px solid var(--verde-dunnas);">
                <h2 style="color: var(--marrom-dunnas); margin-top: 0;">Módulo ${perfil}</h2>
                <p>Seja bem-vindo ao portal do Condomínio Dunnas. Utilize o menu lateral para gerenciar suas atividades.</p>
                <p style="font-size: 0.9em; color: #666;">Dica: Caso tenha problemas técnicos, entre em contato com a administração.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>