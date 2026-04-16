<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Detalhes do Chamado #${chamado.id} - Dunnas</title>
    <style>
        :root {
            --verde-dunnas: #2d5a27;
            --marrom-dunnas: #4b3621;
            --fundo: #f4f7f1;
            --branco: #ffffff;
            --border: #e0e0e0;
            --info: #0288d1;
            --danger: #c62828;
            --sucesso: #2e7d32;
            --accent: #a5d6a7;
            --bg-comentario-admin: #e8f5e9;
        }
        body { font-family: 'Segoe UI', sans-serif; background: var(--fundo); margin: 0; display: flex; }

        .sidebar {
            width: 250px; background: var(--verde-dunnas); height: 100vh; color: white;
            padding: 20px; position: fixed; box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            display: flex; flex-direction: column; z-index: 1000; box-sizing: border-box;
        }
        .sidebar h2 { font-size: 1.4em; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 15px; margin-bottom: 20px; letter-spacing: 1px; }

        .user-info { padding: 15px; background: rgba(255,255,255,0.1); border-radius: 8px; margin-bottom: 20px; font-size: 0.9em; border-left: 4px solid var(--accent); }
        .user-info span { display: block; color: var(--accent); font-size: 0.75em; text-transform: uppercase; font-weight: bold; }
        .user-info strong { font-size: 1.1em; display: block; margin: 3px 0; overflow: hidden; text-overflow: ellipsis; }

        .sidebar a { display: block; color: white; text-decoration: none; padding: 12px 15px; margin-bottom: 8px; border-radius: 5px; transition: 0.3s; font-size: 0.95em; font-weight: 500; }
        .sidebar a:hover { background: rgba(255,255,255,0.2); padding-left: 20px; }
        .btn-logout { background: var(--danger) !important; margin-top: auto; text-align: center; font-weight: bold !important; }

        .main { margin-left: 290px; padding: 40px; width: calc(100% - 330px); box-sizing: border-box; }

        .header-container { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; border-bottom: 2px solid var(--verde-dunnas); padding-bottom: 15px; }
        .header-container h1 { color: var(--marrom-dunnas); margin: 0; font-size: 1.8em; }

        .btn-voltar { text-decoration: none; color: var(--marrom-dunnas); font-weight: bold; border: 1px solid var(--marrom-dunnas); padding: 8px 18px; border-radius: 5px; transition: 0.3s; font-size: 0.9em; }
        .btn-voltar:hover { background: var(--marrom-dunnas); color: white; }

        .details-grid { display: grid; grid-template-columns: 1.8fr 1.2fr; gap: 25px; }
        .card { background: var(--branco); padding: 25px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.08); margin-bottom: 25px; border-top: 5px solid var(--verde-dunnas); }
        .card h3 { color: var(--marrom-dunnas); margin-top: 0; border-bottom: 1px solid #eee; padding-bottom: 12px; font-size: 1.1em; margin-bottom: 20px; }

        .info-group { margin-bottom: 18px; }
        .info-label { font-size: 0.75em; color: #888; text-transform: uppercase; font-weight: bold; display: block; margin-bottom: 4px; }
        .info-value { font-size: 1em; color: #333; display: block; line-height: 1.5; }

        .badge { padding: 6px 14px; border-radius: 20px; font-weight: bold; font-size: 0.8em; display: inline-block; text-transform: uppercase; }
        .status-ABERTO { background: #fff3cd; color: #856404; }
        .status-EM_ANDAMENTO, .status-EM_ATENDIMENTO { background: #d1ecf1; color: #0c5460; }
        .status-CONCLUIDO, .status-FINALIZADO { background: #d4edda; color: #155724; }

        .img-anexo { max-width: 100%; max-height: 450px; border-radius: 8px; margin-top: 10px; border: 1px solid var(--border); object-fit: contain; }
        .pdf-box { display: flex; align-items: center; gap: 15px; padding: 15px; background: #f8f9fa; border: 1px dashed #ccc; border-radius: 8px; margin-top: 10px; }
        .pdf-icon { font-size: 2.5em; }

        .comment-box { padding: 15px; border-radius: 8px; background: #f9f9f9; border: 1px solid var(--border); margin-bottom: 15px; }
        .is-staff { background: var(--bg-comentario-admin); border-left: 4px solid var(--verde-dunnas); }
        textarea { width: 100%; padding: 12px; border: 1px solid var(--border); border-radius: 8px; resize: vertical; box-sizing: border-box; margin-bottom: 10px; font-family: inherit; }
        .btn-submit { background: var(--verde-dunnas); color: white; border: none; padding: 12px 25px; border-radius: 5px; cursor: pointer; font-weight: bold; transition: 0.3s; }

        .btn-action { width: 100%; padding: 14px; border: none; border-radius: 8px; font-weight: bold; cursor: pointer; transition: 0.3s; margin-bottom: 12px; display: block; text-align: center; text-decoration: none; box-sizing: border-box; }
        .btn-atender { background-color: var(--info); color: white; }
        .btn-concluir { background-color: var(--sucesso); color: white; }
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
            <a href="/chamados">📋 Meus Chamados</a>
            <a href="/chamados/novo">➕ Abrir Chamado</a>
        </c:otherwise>
    </c:choose>

    <a href="/logout" class="btn-logout" onclick="return confirm('Sair do sistema?')">Sair do Sistema</a>
</div>

<div class="main">
    <div class="header-container">
        <h1> Detalhes do Chamado #${chamado.id}</h1>
        <a href="/chamados" class="btn-voltar">← Voltar para Lista</a>
    </div>

    <div class="details-grid">
        <div class="content-left">
            <div class="card">
                <h3> Descrição da Ocorrência</h3>
                <div class="info-group">
                    <span class="info-label">Título</span>
                    <span class="info-value" style="font-size: 1.2em; font-weight: bold; color: var(--marrom-dunnas);">${chamado.titulo}</span>
                </div>
                <div class="info-group">
                    <span class="info-label">Relato Detalhado</span>
                    <span class="info-value" style="white-space: pre-wrap; background: #fcfcfc; padding: 15px; border-radius: 5px; border: 1px solid #f0f0f0;">${chamado.descricao}</span>
                </div>

                <c:if test="${not empty chamado.midiaUrl}">
                    <div class="info-group">
                        <span class="info-label">Evidência / Anexo</span>
                        <c:set var="urlAnexo" value="${pageContext.request.contextPath}/uploads/${chamado.midiaUrl}" />
                        <c:choose>
                            <c:when test="${chamado.midiaUrl.toLowerCase().endsWith('.pdf')}">
                                <div class="pdf-box">
                                    <span class="pdf-icon">📄</span>
                                    <div>
                                        <strong>Documento PDF</strong><br>
                                        <a href="${urlAnexo}" target="_blank" class="btn-voltar" style="padding: 5px 10px; font-size: 0.8em; margin-top: 5px; display: inline-block;">Visualizar</a>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <a href="${urlAnexo}" target="_blank">
                                    <img src="${urlAnexo}" alt="Anexo" class="img-anexo">
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>
            </div>

            <div class="card">
                <h3> Histórico de Conversas</h3>
                <div class="comments-list">
                    <c:forEach items="${chamado.comentarios}" var="com">
                        <div class="comment-box ${com.autor.getClass().getSimpleName() != 'Morador' ? 'is-staff' : ''}">
                            <div class="comment-header" style="display: flex; justify-content: space-between; font-size: 0.85em; margin-bottom: 8px;">
                                <span style="font-weight: bold; color: var(--marrom-dunnas);">${com.autor.nome} <small>(${com.autor.getClass().getSimpleName()})</small></span>
                                <span style="color: #888;">
                                    <fmt:parseDate value="${com.dataCriacao}" pattern="yyyy-MM-dd'T'HH:mm" var="pDate" type="both" />
                                    <fmt:formatDate value="${pDate}" pattern="dd/MM HH:mm" />
                                </span>
                            </div>
                            <div>${com.texto}</div>
                        </div>
                    </c:forEach>
                </div>
                <form action="/chamados/comentar" method="post" style="margin-top: 20px;">
                    <input type="hidden" name="chamadoId" value="${chamado.id}">
                    <textarea name="texto" rows="3" placeholder="Sua resposta..." required></textarea>
                    <button type="submit" class="btn-submit">Enviar Resposta</button>
                </form>
            </div>
        </div>

        <div class="content-right">
            <div class="card">
                <h3> Gestão de Atendimento</h3>
                <c:choose>
                    <c:when test="${perfil == 'ADMIN' || perfil == 'COLABORADOR'}">
                        <c:choose>
                            <c:when test="${chamado.status == 'ABERTO'}">
                                <a href="/chamados/atender/${chamado.id}" class="btn-action btn-atender">▶️ Iniciar Atendimento</a>
                            </c:when>
                            <c:when test="${chamado.status == 'EM_ANDAMENTO' || chamado.status == 'EM_ATENDIMENTO'}">
                                <a href="/chamados/concluir/${chamado.id}" class="btn-action btn-concluir">✅ Finalizar Chamado</a>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; color: var(--sucesso); font-weight: bold;">Status: Finalizado</div>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <p style="text-align: center; color: #888; font-size: 0.9em;">Aguardando equipe técnica.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card">
                <h3> Informações Gerais</h3>
                <div class="info-group">
                    <span class="info-label">Status Atual</span>
                    <span class="badge status-${chamado.status}">${chamado.status}</span>
                </div>
                <div class="info-group">
                    <span class="info-label">Data de Abertura</span>
                    <span class="info-value">
                        <fmt:parseDate value="${chamado.dataAbertura}" pattern="yyyy-MM-dd'T'HH:mm" var="pAb" type="both" />
                        <fmt:formatDate value="${pAb}" pattern="dd/MM/yyyy HH:mm" />
                    </span>
                </div>
                <%-- REQUISITO: SLA (Data Limite) --%>
                <c:if test="${not empty chamado.dataLimite}">
                    <div class="info-group">
                        <span class="info-label">Prazo de Resolução (SLA)</span>
                        <span class="info-value" style="color: ${chamado.status != 'CONCLUIDO' ? 'var(--danger)' : '#333'}">
                            <fmt:parseDate value="${chamado.dataLimite}" pattern="yyyy-MM-dd'T'HH:mm" var="pLim" type="both" />
                            <fmt:formatDate value="${pLim}" pattern="dd/MM/yyyy" />
                        </span>
                    </div>
                </c:if>
                <%-- REQUISITO: Data de Finalização --%>
                <c:if test="${not empty chamado.dataFinalizacao}">
                    <div class="info-group">
                        <span class="info-label">Finalizado em</span>
                        <span class="info-value" style="color: var(--sucesso); font-weight: bold;">
                            <fmt:parseDate value="${chamado.dataFinalizacao}" pattern="yyyy-MM-dd'T'HH:mm" var="pFin" type="both" />
                            <fmt:formatDate value="${pFin}" pattern="dd/MM/yyyy HH:mm" />
                        </span>
                    </div>
                </c:if>
            </div>

            <div class="card">
                <h3> Solicitante e Local</h3>
                <div class="info-group"><span class="info-label">Morador</span><span class="info-value"><strong>${chamado.morador.nome}</strong></span></div>
                <div class="info-group"><span class="info-label">Unidade</span><span class="info-value">${chamado.unidade.identificacao}</span></div>
                <div class="info-group"><span class="info-label">Categoria</span><span class="info-value">${chamado.categoria.nome}</span></div>
            </div>
        </div>
    </div>
</div>
</body>
</html>