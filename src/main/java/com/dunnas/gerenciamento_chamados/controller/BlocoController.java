package com.dunnas.gerenciamento_chamados.controller;

import com.dunnas.gerenciamento_chamados.model.Bloco;
import com.dunnas.gerenciamento_chamados.model.Chamado;
import com.dunnas.gerenciamento_chamados.service.*;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequiredArgsConstructor
public class BlocoController {

    private final BlocoService blocoService;
    private final MoradorService moradorService;
    private final ChamadoService chamadoService;
    private final ColaboradorService colaboradorService;

    @GetMapping("/")
    public String index(HttpSession session, Model model) {
        String perfil = (String) session.getAttribute("perfil");

        if (perfil == null) {
            return "redirect:/login";
        }

        if ("COLABORADOR".equals(perfil)) {
            return "redirect:/chamados/dashboard-colaborador";
        }
        if ("MORADOR".equals(perfil)) {
            return "redirect:/chamados/dashboard-morador";
        }

        // Dashboard ADMIN
        List<Chamado> todosChamados = chamadoService.listarTodos();

        model.addAttribute("totalMoradores", moradorService.listarTodos().size());
        model.addAttribute("totalColaboradores", colaboradorService.listarTodos().size());

        long abertos = todosChamados.stream()
                .filter(c -> "ABERTO".equalsIgnoreCase(c.getStatus()))
                .count();
        model.addAttribute("totalChamadosAbertos", abertos);
        model.addAttribute("chamadosAtrasados", 0);

        List<Chamado> recentes = todosChamados.stream()
                .sorted((c1, c2) -> c2.getId().compareTo(c1.getId()))
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("chamadosRecentes", recentes);

        return "index";
    }

    // --- CRUD DE BLOCOS ---

    @GetMapping("/blocos")
    public String listarBlocos(HttpSession session, Model model) {
        if (!"ADMIN".equals(session.getAttribute("perfil"))) {
            return "redirect:/login";
        }

        // Passando dados da sessão para o Model (necessário para a sidebar padronizada)
        model.addAttribute("usuarioLogado", session.getAttribute("usuarioLogado"));
        model.addAttribute("perfil", session.getAttribute("perfil"));

        model.addAttribute("blocos", blocoService.listarTodos());
        return "lista-blocos";
    }

    @GetMapping("/blocos/novo")
    public String exibirFormulario(HttpSession session, Model model) {
        if (!"ADMIN".equals(session.getAttribute("perfil"))) {
            return "redirect:/login";
        }

        model.addAttribute("usuarioLogado", session.getAttribute("usuarioLogado"));
        model.addAttribute("perfil", session.getAttribute("perfil"));

        model.addAttribute("bloco", new Bloco());
        return "cadastro-bloco";
    }

    @PostMapping("/blocos/salvar")
    public String salvar(@ModelAttribute("bloco") Bloco bloco, HttpSession session, RedirectAttributes attr) {
        if (!"ADMIN".equals(session.getAttribute("perfil"))) {
            return "redirect:/login";
        }

        try {
            blocoService.salvarBloco(bloco);
            // Mensagem dinâmica para o aviso que você solicitou
            attr.addFlashAttribute("mensagemSucesso", "O bloco '" + bloco.getIdentificacao() + "' e todas as suas unidades foram criados com sucesso!");
        } catch (Exception e) {
            attr.addFlashAttribute("mensagemErro", "Erro ao processar bloco: " + e.getMessage());
            return "redirect:/blocos/novo";
        }

        return "redirect:/blocos";
    }

    @GetMapping("/blocos/excluir/{id}")
    public String excluir(@PathVariable Long id, HttpSession session, RedirectAttributes attr) {
        if (!"ADMIN".equals(session.getAttribute("perfil"))) {
            return "redirect:/login";
        }

        try {
            blocoService.excluir(id);
            attr.addFlashAttribute("mensagemSucesso", "Bloco e unidades removidos com sucesso do sistema.");
        } catch (Exception e) {
            attr.addFlashAttribute("mensagemErro", "Não foi possível excluir o bloco selecionado.");
        }

        return "redirect:/blocos";
    }

    @GetMapping("/blocos/editar/{id}")
    public String editar(@PathVariable Long id, HttpSession session, Model model) {
        if (!"ADMIN".equals(session.getAttribute("perfil"))) {
            return "redirect:/login";
        }

        model.addAttribute("usuarioLogado", session.getAttribute("usuarioLogado"));
        model.addAttribute("perfil", session.getAttribute("perfil"));

        model.addAttribute("bloco", blocoService.buscarPorId(id));
        return "cadastro-bloco"; // Reutiliza o mesmo formulário de cadastro
    }
}