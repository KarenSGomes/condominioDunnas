<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>${empty bloco.id ? 'Novo Bloco' : 'Editar Bloco'} - Dunnas</title>
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
            width: 250px; background: var(--verde-dunnas); height: 100vh; color: white;
            padding: 20px; position: fixed; box-shadow: 2px 0 5px rgba(0,0,0,0.1);
            display: flex; flex-direction: column; z-index: 1000; box-sizing: border-box;
        }

        .sidebar h2 { font-size: 1.4em; text-align: center; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 15px; margin-bottom: 20px; }

        .user-info { padding: 15px; background: rgba(255,255,255,0.1); border-radius: 8px; margin-bottom: 20px; font-size: 0.9em; border-left: 4px solid var(--accent); }
        .user-info span { display: block; color: var(--accent); font-size: 0.75em; text-transform: uppercase; font-weight: bold; }
        .user-info strong { font-size: 1.1em; display: block; margin: 3px 0; overflow: hidden; text-overflow: ellipsis; }

        .sidebar a { display: block; color: white; text-decoration: none; padding: 12px 15px; margin-bottom: 8px; border-radius: 5px; transition: 0.3s; font-size: 0.95em; }
        .sidebar a:hover { background: rgba(255,255,255,0.2); padding-left: 20px; }

        .btn-logout { background: var(--danger) !important; margin-top: auto; text-align: center; font-weight: bold !important; }

        /* Main Content */
        .main { margin-left: 290px; padding: 40px; width: calc(100% - 330px); }
        h1 { color: var(--marrom-dunnas); margin-bottom: 25px; }

        .form-container {
            background: white; padding: 35px; border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border-top: 5px solid var(--marrom-dunnas); max-width: 600px;
        }

        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: bold; color: var(--marrom-dunnas); margin-bottom: 8px; }
        input { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 8px; box-sizing: border-box; font-size: 1rem; }

        /* Estilo para campos somente leitura na edição */
        input[readonly] { background-color: #f0f0f0; cursor: not-allowed; color: #777; }

        .btn-submit {
            background: var(--verde-dunnas); color: white; border: none; padding: 14px 25px;
            border-radius: 8px; cursor: pointer; font-size: 1.1em; font-weight: bold; transition: 0.3s; width: 100%;
        }
        .btn-submit:hover { background: #1e3d1a; transform: translateY(-1px); }

        .info-box { background: #e7f3ff; border-left: 4px solid #007bff; padding: 15px; margin-bottom: 25px; border-radius: 8px; }
        .info-box p { margin: 0; font-size: 0.9em; color: #0056b3; line-height: 1.4; }

        .btn-cancel { display: block; text-align: center; color: #666; text-decoration: none; margin-top: 20px; font-weight: 500; }
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
    <a href="/logout" class="btn-logout" onclick="return confirm('Sair do sistema?')">Sair</a>
</div>

<div class="main">
    <h1>${empty bloco.id ? ' Cadastrar Novo Bloco' : ' Editar Bloco'}</h1>

    <div class="form-container">
        <c:if test="${empty bloco.id}">
            <div class="info-box">
                <p><strong>ATENÇÃO:</strong> Ao salvar, o sistema gerará automaticamente todos os apartamentos. Essa estrutura não poderá ser alterada depois para evitar erros com moradores já cadastrados.</p>
            </div>
        </c:if>

        <form:form action="/blocos/salvar" method="post" modelAttribute="bloco">

            <%-- CAMPO ESSENCIAL PARA O BOTÃO FUNCIONAR --%>
            <form:hidden path="id" />

            <div class="form-group">
                <label>Identificação do Bloco:</label>
                <form:input path="identificacao" required="true" placeholder="Ex: Bloco A" />
            </div>

            <div class="form-group">
                <label>Quantidade de Andares:</label>
                    <%-- Na edição (id não vazio), o campo fica readonly --%>
                <form:input path="qtdAndares" type="number" required="true" min="1"
                            readonly="${not empty bloco.id}" placeholder="Ex: 10" />
            </div>

            <div class="form-group">
                <label>Apartamentos por Andar:</label>
                <form:input path="aptosPorAndar" type="number" required="true" min="1"
                            readonly="${not empty bloco.id}" placeholder="Ex: 4" />
            </div>

            <div style="margin-top: 35px;">
                <button type="submit" class="btn-submit">
                        ${empty bloco.id ? 'Gerar Estrutura Completa' : 'Salvar Alterações'}
                </button>
                <a href="/blocos" class="btn-cancel">Cancelar e Voltar</a>
            </div>
        </form:form>
    </div>
</div>

</body>
</html>