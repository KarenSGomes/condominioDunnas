<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Novo Chamado | Dunnas</title>
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
        .main { margin-left: 290px; padding: 40px; width: calc(100% - 330px); box-sizing: border-box; }

        h1 { color: var(--marrom-dunnas); margin: 0; font-size: 1.8em; }
        .subtitle { color: #666; margin-bottom: 30px; }

        /* Form Container */
        .form-container {
            background: white;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
            width: 100%;
            max-width: 700px;
            border-top: 5px solid var(--verde-dunnas);
        }

        .form-group { margin-bottom: 25px; }
        label { display: block; font-weight: bold; color: var(--marrom-dunnas); margin-bottom: 10px; }

        input, select, textarea {
            width: 100%; padding: 14px; border: 1px solid #ddd; border-radius: 8px;
            box-sizing: border-box; font-size: 1rem; transition: 0.3s; font-family: inherit;
        }

        input:focus, select:focus, textarea:focus { border-color: var(--verde-dunnas); outline: none; box-shadow: 0 0 8px rgba(45,90,39,0.1); }

        input[type="file"] { background: #fcfcfc; padding: 10px; border: 1px dashed #ccc; }

        .btn-submit {
            background: var(--verde-dunnas); color: white; border: none; padding: 16px;
            border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 1.1em; width: 100%; transition: 0.3s;
        }
        .btn-submit:hover { background: #1e3d1a; transform: translateY(-1px); box-shadow: 0 4px 8px rgba(0,0,0,0.1); }

        .btn-cancel { display: block; text-align: center; margin-top: 20px; color: #777; text-decoration: none; font-size: 0.95em; font-weight: 500; }
        .btn-cancel:hover { color: var(--danger); text-decoration: underline; }
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
    <h1> Abrir Novo Chamado</h1>
    <p class="subtitle">Preencha os detalhes abaixo para solicitar manutenção ou suporte técnico.</p>

    <div class="form-container">
        <form:form action="/chamados/salvar" method="post" modelAttribute="chamado" enctype="multipart/form-data">

            <div class="form-group">
                <label>Onde está o problema? (Unidade):</label>
                <form:select path="unidade.id" required="true">
                    <form:option value="" label="-- Selecione a Unidade --"/>
                    <form:options items="${unidadesDoMorador}" itemValue="id" itemLabel="identificacao" />
                </form:select>
            </div>

            <div class="form-group">
                <label>Categoria da Ocorrência:</label>
                <form:select path="categoria.id" required="true">
                    <form:option value="" label="-- Selecione o Tipo --"/>
                    <form:options items="${categorias}" itemValue="id" itemLabel="nome" />
                </form:select>
            </div>

            <div class="form-group">
                <label>Resumo (Título):</label>
                <form:input path="titulo" required="true" placeholder="Ex: Goteira no teto da cozinha" maxlength="100" />
            </div>

            <div class="form-group">
                <label>Descrição Detalhada:</label>
                <form:textarea path="descricao" rows="5" required="true" placeholder="Descreva o que está acontecendo com o máximo de detalhes possível..." />
            </div>

            <div class="form-group">
                <label>Anexar Evidência (Opcional):</label>
                <input type="file" name="anexo" accept="image/*" />
                <small style="color: #999; display: block; margin-top: 8px;">Dica: Uma foto ajuda o técnico a entender o problema mais rápido.</small>
            </div>

            <button type="submit" class="btn-submit">Enviar Solicitação</button>
            <a href="/chamados/dashboard-morador" class="btn-cancel">Cancelar e voltar</a>
        </form:form>
    </div>
</div>

</body>
</html>