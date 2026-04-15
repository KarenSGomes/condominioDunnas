<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="morador" type="com.dunnas.gerenciamento_chamados.model.Morador"--%>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>${morador.id == null ? 'Novo' : 'Editar'} Morador - Dunnas</title>
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
        .main { margin-left: 290px; padding: 40px; width: calc(100% - 330px); }

        h1 { color: var(--marrom-dunnas); margin-bottom: 25px; }

        .form-container {
            background: white;
            padding: 35px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            border-top: 5px solid var(--marrom-dunnas);
            max-width: 600px;
        }

        .form-group { margin-bottom: 20px; }
        label { display: block; font-weight: bold; color: var(--marrom-dunnas); margin-bottom: 8px; }
        input { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 8px; box-sizing: border-box; font-size: 1em; transition: 0.3s; }
        input:focus { border-color: var(--verde-dunnas); outline: none; box-shadow: 0 0 5px rgba(45,90,39,0.1); }

        /* Checkboxes de Unidades */
        .units-container {
            max-height: 180px; overflow-y: auto; background: #fdfdfd;
            padding: 15px; border: 1px solid #eee; border-radius: 8px;
            display: grid; grid-template-columns: 1fr 1fr; gap: 10px;
        }
        .unit-item { display: flex; align-items: center; gap: 8px; font-weight: normal; cursor: pointer; color: #333; padding: 5px; border-radius: 5px; transition: 0.2s; }
        .unit-item:hover { background: #f0f4ef; }
        .unit-item input { width: 18px; height: 18px; margin: 0; cursor: pointer; }

        .btn-container { display: flex; gap: 15px; margin-top: 35px; }

        .btn-submit {
            flex: 2; padding: 14px; background: var(--verde-dunnas); color: white; border: none;
            border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 1em; transition: 0.3s;
        }
        .btn-submit:hover { background: #1e3d1a; transform: translateY(-1px); }

        .btn-cancel {
            flex: 1; padding: 14px; background: #eee; text-decoration: none; text-align: center;
            color: #666; border-radius: 8px; font-weight: bold; transition: 0.3s;
        }
        .btn-cancel:hover { background: #e0e0e0; color: var(--danger); }

        /* Alertas */
        .alert { padding: 15px; margin-bottom: 20px; border-radius: 8px; font-weight: bold; }
        .alert-danger { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>

    <script>
        function mascaraCPF(i) {
            let v = i.value.replace(/\D/g, "");
            if (v.length > 11) v = v.substring(0, 11);
            v = v.replace(/(\d{3})(\d)/, "$1.$2");
            v = v.replace(/(\d{3})(\d)/, "$1.$2");
            v = v.replace(/(\d{3})(\d{1,2})$/, "$1-$2");
            i.value = v;
        }

        function mascaraTelefone(i) {
            let v = i.value.replace(/\D/g, "");
            if (v.length > 11) v = v.substring(0, 11);
            v = v.replace(/^(\d{2})(\d)/g, "($1) $2");
            v = v.replace(/(\d{5})(\d)/, "$1-$2");
            i.value = v;
        }
    </script>
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
    <h1>
        ${morador.id == null ? '➕ Cadastrar Novo Morador' : ' Editar Morador'}
    </h1>

    <c:if test="${not empty mensagemErro}">
        <div class="alert alert-danger">❌ ${mensagemErro}</div>
    </c:if>

    <div class="form-container">
        <form:form action="/moradores/salvar" method="post" modelAttribute="morador">

            <form:hidden path="id" />

            <div class="form-group">
                <label>Nome Completo:</label>
                <form:input path="nome" required="true" placeholder="Ex: Maria Oliveira" />
            </div>

            <div class="form-group">
                <label>E-mail de Acesso:</label>
                <form:input path="email" type="email" required="true" placeholder="exemplo@dunnas.com" />
            </div>

            <div class="form-group">
                <label>Senha:</label>
                <form:input path="senha" type="password" required="${morador.id == null}"
                            placeholder="${morador.id == null ? 'Senha provisória' : 'Deixe vazio para manter a atual'}" />
            </div>

            <div class="form-group">
                <label>CPF:</label>
                <form:input path="cpf" required="true" oninput="mascaraCPF(this)" maxlength="14" placeholder="000.000.000-00" />
            </div>

            <div class="form-group">
                <label>Telefone:</label>
                <form:input path="telefone" oninput="mascaraTelefone(this)" maxlength="15" placeholder="(00) 00000-0000" />
            </div>

            <div class="form-group">
                <label>Vincular Unidades:</label>
                <div class="units-container">
                    <form:checkboxes path="unidades" items="${listaUnidades}" itemValue="id" itemLabel="identificacao" element="label class='unit-item'" />
                </div>
                <small style="color: #888;">Selecione todos os apartamentos pertencentes a este morador.</small>
            </div>

            <div class="btn-container">
                <button type="submit" class="btn-submit">Finalizar Cadastro</button>
                <a href="/moradores" class="btn-cancel">Cancelar</a>
            </div>
        </form:form>
    </div>
</div>

</body>
</html>