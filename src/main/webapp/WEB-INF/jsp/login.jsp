<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Condomínio Dunnas</title>
    <style>
        :root {
            --verde-dunnas: #2d5a27;
            --marrom-dunnas: #4b3621;
            --fundo: #f4f7f1;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            background: var(--fundo);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .login-card {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            border-top: 8px solid var(--verde-dunnas);
            text-align: center;
        }

        .login-card h2 {
            color: var(--marrom-dunnas);
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .login-card p {
            color: #666;
            margin-bottom: 30px;
            font-size: 0.9em;
        }

        .form-group {
            text-align: left;
            margin-bottom: 20px;
        }

        label {
            display: block;
            font-weight: bold;
            color: var(--marrom-dunnas);
            margin-bottom: 5px;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 1em;
            transition: 0.3s;
        }

        input:focus {
            border-color: var(--verde-dunnas);
            outline: none;
            box-shadow: 0 0 5px rgba(45, 90, 39, 0.2);
        }

        .btn-entrar {
            width: 100%;
            background: var(--verde-dunnas);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 8px;
            font-size: 1.1em;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 10px;
        }

        .btn-entrar:hover {
            background: #1e3d1a;
            transform: translateY(-2px);
        }

        .error-msg {
            background: #fee;
            color: #c00;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 0.85em;
        }
    </style>
</head>
<body>

<div class="login-card">
    <h2>CONDOMÍNIO DUNNAS</h2>
    <p>Sistema de Gerenciamento de Chamados</p>

    <%-- Mensagem de erro caso o login falhe --%>
    <% if (request.getAttribute("erro") != null) { %>
    <div class="error-msg">
        <%= request.getAttribute("erro") %>
    </div>
    <% } %>

    <form action="/login" method="post">
        <div class="form-group">
            <label>E-mail</label>
            <input type="email" name="email" required placeholder="seu@email.com">
        </div>

        <div class="form-group">
            <label>Senha</label>
            <input type="password" name="senha" required placeholder="••••••••">
        </div>

        <button type="submit" class="btn-entrar">Entrar no Sistema</button>
    </form>
</div>

</body>
</html>