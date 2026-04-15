package com.dunnas.gerenciamento_chamados.controller;

import com.dunnas.gerenciamento_chamados.model.Administrador;
import com.dunnas.gerenciamento_chamados.model.Colaborador;
import com.dunnas.gerenciamento_chamados.model.Morador;
import com.dunnas.gerenciamento_chamados.model.Usuario;
import com.dunnas.gerenciamento_chamados.repository.UsuarioRepository;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Optional;

@Controller
@RequiredArgsConstructor
public class LoginController {

    private final UsuarioRepository usuarioRepository;

    @GetMapping("/login")
    public String telaLogin() {
        return "login";
    }

    @PostMapping("/login")
    @Transactional(readOnly = true)
    public String autenticar(@RequestParam("email") String email,
                             @RequestParam("senha") String senha,
                             HttpSession session,
                             Model model) {

        try {
            Optional<Usuario> usuarioOpt = usuarioRepository.findByEmail(email);

            if (usuarioOpt.isPresent()) {
                Usuario usuario = usuarioOpt.get();

                // Comparação de senha em texto puro (conforme seu .equals)
                if (usuario.getSenha().equals(senha)) {

                    // Salvando o objeto inteiro na sessão
                    session.setAttribute("usuarioLogado", usuario);

                    // Descobrindo o nome da classe real (lida com Proxies do Hibernate)
                    String tipoClasse = usuario.getClass().getSimpleName();

                    // Redirecionamento baseado no tipo detectado
                    if (tipoClasse.contains("Administrador")) {
                        session.setAttribute("perfil", "ADMIN");
                        return "redirect:/"; // Vai para o IndexController
                    }
                    else if (tipoClasse.contains("Colaborador")) {
                        session.setAttribute("perfil", "COLABORADOR");
                        return "redirect:/chamados/dashboard-colaborador";
                    }
                    else if (tipoClasse.contains("Morador")) {
                        session.setAttribute("perfil", "MORADOR");
                        return "redirect:/chamados/dashboard-morador";
                    }
                }
            }

            // Se chegou aqui, algo falhou
            model.addAttribute("erro", "E-mail ou senha inválidos.");
            return "login";

        } catch (Exception e) {
            model.addAttribute("erro", "Erro interno: " + e.getMessage());
            e.printStackTrace();
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}