package com.dunnas.gerenciamento_chamados.controller;

import com.dunnas.gerenciamento_chamados.model.Administrador;
import com.dunnas.gerenciamento_chamados.service.AdministradorService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admins")
@RequiredArgsConstructor
public class AdministradorController {

    private final AdministradorService adminService;

    @GetMapping
    public String listar(Model model) {
        model.addAttribute("administradores", adminService.listarTodos());
        return "lista-admins";
    }

    @GetMapping("/novo")
    public String exibirFormulario(Model model) {
        model.addAttribute("admin", new Administrador());
        return "cadastro-admin";
    }

    @PostMapping("/salvar")
    public String salvar(@ModelAttribute("admin") Administrador admin, RedirectAttributes attr) {
        adminService.salvar(admin);
        attr.addFlashAttribute("mensagemSucesso", "Administrador salvo com sucesso!");
        return "redirect:/admins";
    }

    @GetMapping("/editar/{id}")
    public String editar(@PathVariable Long id, Model model) {
        model.addAttribute("admin", adminService.buscarPorId(id));
        return "cadastro-admin";
    }

    @GetMapping("/excluir/{id}")
    public String excluir(@PathVariable Long id, RedirectAttributes attr) {
        try {
            adminService.deletar(id);
            attr.addFlashAttribute("mensagemSucesso", "Administrador removido com sucesso.");
        } catch (RuntimeException e) {
            // Captura a mensagem de erro do Service (ex: "O sistema deve possuir pelo menos um administrador")
            attr.addFlashAttribute("mensagemErro", e.getMessage());
        }
        return "redirect:/admins";
    }
}