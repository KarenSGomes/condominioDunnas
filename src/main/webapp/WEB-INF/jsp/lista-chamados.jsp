<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Gestão de Chamados - Dunnas</title>
    <style>
        :root {
            --verde-dunnas: #2d5a27;
            --marrom-dunnas: #4b3621;
            --fundo: #f4f7f1;
            --danger: #c62828;
            --accent: #a5d6a7;
            --info: #0288d1;
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
        }
        .btn-add:hover { background: #1e3d1a; transform: translateY(-1px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }

        /* Tabela */
        .table-container { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); margin-top: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8f9fa; color: var(--marrom-dunnas); padding: 15px; text-align: left; border-bottom: 2px solid #eee; font-size: 0.85em; text-transform: uppercase; font-weight: bold; }
        td { padding: 15px; border-bottom: 1px solid #eee; vertical-align: middle; font-size: 0.95em; color: #333; }

        /* Badges de Status */
        .badge { padding: 6px 12px; border-radius: 20px; font-size: 0.75em; font-weight: bold; text-transform: uppercase; display: inline-block; }
        .status-ABERTO { background: #fff3cd; color: #856404; }
        .status-EM_ANDAMENTO, .status-EM_ATENDIMENTO { background: #d1ecf1; color: #0c5460; }
        .status-CONCLUIDO, .status-FINALIZADO { background: #d4edda; color: #155724; }

        /* Ações */
        .actions { display: flex; gap: 12px; }
        .btn-action { text-decoration: none; font-size: 1.2em; transition: 0.2s; }
        .btn-action:hover { transform: scale(1.2); }
        .btn-edit { color: var(--info); }
        .btn-view { color: var(--verde-dunnas); }
        .btn-del { color: var(--danger); }

        /* Alertas */
        .alert { padding: 15px; border-radius: 8px; margin-bottom: 25px; font-weight: bold; border-left: 5px solid; }
        .alert-success { background-color: #d4edda; color: #155724; border-left-color: #2e7d32; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border-left-color: var(--danger); }
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
            <a href="/chamados/dashboard-colaborador">🏠 Dashboard</a>
            <a href="/chamados">📋 Chamados no Escopo</a>
        </c:when>
        <c:otherwise>
            <a href="/chamados/dashboard-morador">🏠 Dashboard</a>
            <a href="/chamados/novo">➕ Novo Chamado</a>
            <a href="/chamados">📋 Meus Chamados</a>
        </c:otherwise>
    </c:choose>

    <a href="/logout" class="btn-logout"
       onclick="return confirm('Tem certeza que deseja sair do sistema Condomínio Dunnas?')">
        Sair do Sistema
    </a>
</div>

<div class="main">
    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 20px;">
        <div>
            <h1>${perfil == 'ADMIN' ? 'Gestão de Chamados' : 'Meus Chamados'}</h1>
            <p style="color: #666; margin: 5px 0 0 0;">Listagem geral de ocorrências e manutenções do condomínio.</p>
        </div>

        <c:if test="${perfil == 'ADMIN' || perfil == 'MORADOR'}">
            <a href="${perfil == 'ADMIN' ? '/chamados/novo/admin' : '/chamados/novo'}" class="btn-add">
                + Abrir Novo Chamado
            </a>
        </c:if>
    </div>

    <%-- Mensagens de Feedback --%>
    <c:if test="${not empty mensagemSucesso}">
        <div class="alert alert-success">✅ ${mensagemSucesso}</div>
    </c:if>

    <c:if test="${not empty mensagemErro}">
        <div class="alert alert-danger">❌ ${mensagemErro}</div>
    </c:if>

    <div class="table-container">
        <table>
            <thead>
            <tr>
                <th>Protocolo</th>
                <th>Título</th>
                <c:if test="${perfil == 'ADMIN'}">
                    <th>Morador</th>
                    <th>Categoria</th>
                </c:if>
                <th>Unidade</th>
                <th>Data</th>
                <th>Status</th>
                <th>Ações</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${chamados}" var="ch">
                <tr>
                    <td><small style="color: #888; font-weight: bold;">#${ch.id}</small></td>
                    <td><strong>${ch.titulo}</strong></td>

                    <c:if test="${perfil == 'ADMIN'}">
                        <td>${ch.morador.nome}</td>
                        <td><small class="badge" style="background: #eee; color: #666;">${ch.categoria.nome}</small></td>
                    </c:if>

                    <td><span style="color: var(--verde-dunnas); font-weight: 600;">${ch.unidade.identificacao}</span></td>
                    <td>
                        <fmt:parseDate value="${ch.dataAbertura}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                        <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                    </td>
                    <td><span class="badge status-${ch.status}">${ch.status}</span></td>
                    <td class="actions">
                        <a href="/chamados/detalhes/${ch.id}" class="btn-action btn-view" title="Visualizar Detalhes">👁️</a>

                        <c:if test="${perfil == 'ADMIN' || (perfil == 'MORADOR' && ch.status == 'ABERTO')}">
                            <a href="/chamados/editar/${ch.id}" class="btn-action btn-edit" title="Editar Informações">✏️</a>
                            <a href="/chamados/excluir/${ch.id}" class="btn-action btn-del" title="Excluir Registro"
                               onclick="return confirm('Excluir este chamado permanentemente? Esta ação não pode ser desfeita.')">🗑️</a>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>

        <c:if test="${empty chamados}">
            <div style="text-align: center; padding: 40px; color: #999; font-style: italic;">
                Nenhum chamado encontrado para os critérios de busca.
            </div>
        </c:if>
    </div>
</div>

</body>
</html>