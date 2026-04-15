<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Painel do Colaborador | Dunnas</title>
    <style>
        :root {
            --verde-dunnas: #2d5a27;
            --marrom-dunnas: #4b3621;
            --fundo: #f4f7f1;
            --danger: #c62828;
            --accent: #a5d6a7;
            --azul-status: #2196f3;
            --laranja-status: #ff9800;
            --verde-sucesso: #4caf50;
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

        .welcome-msg { color: var(--marrom-dunnas); margin: 0; font-size: 1.8em; }
        .sub-msg { color: #666; margin-bottom: 30px; }

        /* Cards de Status */
        .cards-container { display: flex; gap: 20px; margin-bottom: 30px; }
        .card-status {
            padding: 20px; flex: 1; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            display: flex; flex-direction: column; justify-content: center; background: white;
            border-top: 5px solid var(--verde-dunnas);
        }
        .card-status h3 { margin: 0; font-size: 0.8em; text-transform: uppercase; letter-spacing: 1px; color: #888; }
        .card-status p { margin: 10px 0 0; font-size: 2.2em; font-weight: bold; color: var(--marrom-dunnas); }

        /* Tabela */
        .table-container { background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        .header-tabela { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; border-bottom: 2px solid var(--verde-dunnas); padding-bottom: 10px; }

        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 15px; border-bottom: 2px solid #eee; color: var(--marrom-dunnas); font-size: 0.85em; text-transform: uppercase; font-weight: bold; }
        td { padding: 15px; border-bottom: 1px solid #f9f9f9; color: #333; font-size: 0.95em; }

        /* Badges */
        .badge { padding: 6px 12px; border-radius: 20px; font-size: 0.75em; font-weight: bold; text-transform: uppercase; }
        .badge-aberto { background: #fff3cd; color: #856404; }
        .badge-em_andamento, .badge-em_atendimento { background: #d1ecf1; color: #0c5460; }

        /* Botões de Ação */
        .btn-acao { padding: 8px 16px; border-radius: 5px; text-decoration: none; font-weight: bold; font-size: 0.8em; transition: 0.3s; display: inline-block; }
        .btn-iniciar { background: var(--info); color: white; }
        .btn-iniciar:hover { background: #0277bd; transform: translateY(-1px); }

        .btn-concluir { background: var(--verde-sucesso); color: white; }
        .btn-concluir:hover { background: #2e7d32; transform: translateY(-1px); }

        .btn-ver { color: var(--marrom-dunnas); text-decoration: none; font-weight: bold; margin-left: 10px; font-size: 0.9em; }
        .btn-ver:hover { text-decoration: underline; }

        /* Feedback */
        .alert-success { background: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 25px; font-weight: bold; border-left: 5px solid var(--verde-sucesso); }
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

    <a href="/chamados/dashboard-colaborador">🏠 Dashboard</a>
    <a href="/chamados">📋 Ver Todos os Chamados</a>

    <a href="/logout" class="btn-logout"
       onclick="return confirm('Tem certeza que deseja sair do sistema Condomínio Dunnas?')">
        Sair do Sistema
    </a>
</div>

<div class="main">
    <h1 class="welcome-msg">Bem-vindo(a), ${usuarioLogado.nome}! </h1>
    <p class="sub-msg">Gestão de manutenção e chamados técnicos em aberto.</p>

    <c:if test="${not empty mensagemSucesso}">
        <div class="alert-success">
            ✅ ${mensagemSucesso}
        </div>
    </c:if>

    <div class="cards-container">
        <div class="card-status" style="border-top-color: var(--azul-status);">
            <h3>🆕 Novos Aguardando</h3>
            <p>${qtdNovos}</p>
        </div>
        <div class="card-status" style="border-top-color: var(--laranja-status);">
            <h3>⏳ Em Atendimento</h3>
            <p>${qtdAndamento}</p>
        </div>
        <div class="card-status" style="border-top-color: var(--verde-sucesso);">
            <h3>✅ Concluídos</h3>
            <p>${qtdFinalizados}</p>
        </div>
    </div>

    <div class="table-container">
        <div class="header-tabela">
            <h2 style="color: var(--marrom-dunnas); margin: 0; font-size: 1.3em;">🛠️ Fila de Atividades Prioritárias</h2>
        </div>

        <table>
            <thead>
            <tr>
                <th>Título do Chamado</th>
                <th>Unidade</th>
                <th>Status</th>
                <th>Abertura</th>
                <th>Ações</th>
            </tr>
            </thead>
            <tbody>
            <c:set var="temChamado" value="false" />
            <c:forEach items="${chamados}" var="ch">
                <c:if test="${ch.status != 'CONCLUIDO' && ch.status != 'FINALIZADO'}">
                    <c:set var="temChamado" value="true" />
                    <tr>
                        <td><strong>${ch.titulo}</strong></td>
                        <td><span style="color: var(--info); font-weight: 600;">${ch.unidade.identificacao}</span></td>
                        <td><span class="badge badge-${ch.status.toLowerCase()}">${ch.status}</span></td>
                        <td>
                            <fmt:parseDate value="${ch.dataAbertura}" pattern="yyyy-MM-dd'T'HH:mm" var="pDate" type="both" />
                            <fmt:formatDate value="${pDate}" pattern="dd/MM HH:mm" />
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${ch.status == 'ABERTO'}">
                                    <a href="/chamados/atender/${ch.id}" class="btn-action btn-acao btn-iniciar">Iniciar</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="/chamados/concluir/${ch.id}" class="btn-action btn-acao btn-concluir">Concluir</a>
                                </c:otherwise>
                            </c:choose>
                            <a href="/chamados/detalhes/${ch.id}" class="btn-ver">Ver Detalhes</a>
                        </td>
                    </tr>
                </c:if>
            </c:forEach>

            <c:if test="${!temChamado}">
                <tr>
                    <td colspan="5" style="text-align: center; padding: 40px; color: #999; font-style: italic;">
                        Ótimo trabalho! Não há chamados pendentes na sua fila.
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>